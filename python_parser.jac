import from pathlib { Path }
import from tree_sitter { Parser, Query, Language, QueryCursor, Node as TSNode, Tree }
import tree_sitter_python as tspython;
import from graph_types { FileNode, ClassNode, FunctionNode, BaseNode, Point, Defines, ProjectNode, BaseNode, Calls }
import from jedi { Project as JediProject, Script as JediScript }
import uuid;


obj PythonParser {
    has : priv parser: Parser = None;

    def start()  -> ProjectNode {
        PY = Language(tspython.language());
        self.parser = Parser(PY);
        # start building repo map
        project =
            self.build_repomap("workplace");
        return project;
    }

    def build_repomap(root_dir: str) -> ProjectNode {
        project = JediProject(path=root_dir, smart_sys_path=True, );
        project_node = ProjectNode(path=root_dir);
        for fp in self.iter_python_files(root_dir) {
            self.build_defines_graph(project=project_node, path=fp);
        }
        file_nodes = [project_node->:Defines :->( ` ? FileNode ) ];
        for file in file_nodes {
            script = JediScript(path=file.path, project=project, );
            self.build_references_graph(
                parent_node=file,
                script=script,
                project_node=project_node
            );
        }
        # print(printgraph(node=project_node));
         # with open("example.gv", "w") as f  {
         #     # f.write(printgraph(node=project_node));
         # }
         return project_node;
    }

    def build_references_graph(
        parent_node: node,
        script: JediScript,
        project_node: ProjectNode
    ) {
        # check if this has reference
         if (type(parent_node) == ClassNode or type(parent_node) == FunctionNode ) {
            references =
                script.get_references(
                    line=parent_node.name_point.row + 1,
                    column=parent_node.name_point.column + 1
                );
            for r in references {
                if r.is_definition() {
                    continue;
                }
                r_file_node =
                    self.find_file_from_project(
                        project_node=project_node,
                        path=r.module_path
                    );
                reference_node =
                    self.find_reference_node(
                        parent_node=r_file_node,
                        column=r.column - 1,
                        row=r.line - 1
                    );
                if (reference_node) {
                    reference_node +>: Calls :+> parent_node;
                } else {
                    # print("Reference not found", reference_node);
                    self.find_reference_node(
                        parent_node=r_file_node,
                        column=r.column - 1,
                        row=r.line - 1
                    );
                }
            }
        }
        children = [parent_node->:Defines :->( ` ? BaseNode ) ];
        for child_node in children {
            self.build_references_graph(
                parent_node=child_node,
                script=script,
                project_node=project_node
            );
        }
    }

    def find_file_from_project(project_node: ProjectNode, path: str) {
        files = [project_node->:Defines :->( ` ? FileNode ) ];
        for file in files {
            if file.path.resolve() == path {
                return file;
            }
        }
        return None;
    }

    def find_reference_node(parent_node: BaseNode, row: number, column: number) {
        children = [parent_node->:Defines :->( ` ? BaseNode ) ];
        if (len(children) == 0) {
            return parent_node;
        }
        point = Point(row=row, column=column);
        for child in children {
            if (type(child) == ClassNode or type(child) == FunctionNode ) {
                if (self.cmpPos(point, child.start_point) >= 0
                && self.cmpPos(point, child.end_point) < 0
                ) {
                    return self.find_reference_node(child, row=row, column=column);
                }
            }
        }
        return parent_node;
    }

    def cmpPos(a: Point, b: Point) {
        if (a.row != b.row) {
            return a.row - b.row;
        }
        return a.column - b.column;
    }

    def iter_python_files(root_dir: str) {
        skips = {".git",".venv","venv","__pycache__","node_modules","dist","build"};
        for p in Path(root_dir).rglob("*.py") {
            if (any([ part in skips for part in p.parts ])) {
                continue;
            }
            yield p;
        }
    }

    def node_text(src_bytes: bytes, node: TSNode) {
        return src_bytes[ node.start_byte : node.end_byte ].decode(
            "utf-8",
            errors="ignore"
        );
    }

    def build_defines_graph(project: ProjectNode, path: Path) {
        src = path.read_bytes();
        tree = self.parser.parse(src);
        tree_builder = ConvertFileToJACGraph(src=src, root_node=tree.root_node);
        tree_builder.start(project=project, path=path);
    }
}


obj ConvertFileToJACGraph {
    has : priv src: bytes;
    has : priv root_node: TSNode;
    has file: FileNode = None;

    def start(project: ProjectNode, path: Path) {
        self.file =
            (project +>: Defines() :+> FileNode(
                path=path.resolve(),
                text=self.src.decode("utf-8")
            ))[0];
        self.build_tree(self.file, self.root_node);
    }

    def : priv build_tree(baseNode: BaseNode, tsNode: TSNode) {
        for child in tsNode.children {
            if (child.type == "class_definition") {
                identifier = self.get_childtype_node("identifier", child.children);
                new_node =
                    (baseNode +>: Defines() :+> ClassNode(
                        id=str(uuid.uuid4()),
                        name=self.node_text(identifier),
                        start_point=Point(
                            row=child.start_point.row,
                            column=child.start_point.column
                        ),
                        end_point=Point(
                            row=child.end_point.row,
                            column=child.end_point.column
                        ),
                        name_point=Point(
                            row=identifier.start_point.row,
                            column=identifier.start_point.column
                        ),
                        text=self.node_text(child)
                    ))[0];
                self.build_tree(
                    new_node,
                    self.get_childtype_node("block", child.children)
                );
            } elif (child.type == "function_definition") {
                identifier = self.get_childtype_node("identifier", child.children);
                new_node =
                    (baseNode +>: Defines() :+> FunctionNode(
                        id=str(uuid.uuid4()),
                        name=self.node_text(identifier),
                        start_point=Point(
                            row=child.start_point.row,
                            column=child.start_point.column
                        ),
                        end_point=Point(
                            row=child.end_point.row,
                            column=child.end_point.column
                        ),
                        name_point=Point(
                            row=identifier.start_point.row,
                            column=identifier.start_point.column
                        ),
                        text=self.node_text(child)
                    ))[0];
                self.build_tree(
                    new_node,
                    self.get_childtype_node("block", child.children)
                );
            } else {
                # print("----");
                # print(
                #     "unknown nodetype found in build_tree",
                #     child.type
                # );
                # print('unknown children', child.children);
                # print("----");
                # obj
                # obj CallEdgesAdder {
                # }
                # print("----");
                # print(
                #     "unknown nodetype found in build_tree",
                #     child.type
                # );
                # print('unknown children', child.children);
                # print("----");
                continue;
            }
        }
    }

    def get_childtype_node(required_type: str, ts_nodes: list[TSNode]) {
        for ts_node in ts_nodes {
            if (ts_node.type == required_type) {
                return ts_node;
            }
        }
        raise Error("node type not found in node list") ;
    }

    def node_text(node: TSNode) {
        return self.src[ node.start_byte : node.end_byte ].decode(
            "utf-8",
            errors="ignore"
        );
    }
}
