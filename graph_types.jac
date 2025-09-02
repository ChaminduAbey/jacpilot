import from pathlib { Path }


node BaseNode {}


node ClassNode(BaseNode) {
    has name: str;
    has start_point: Point;
    has end_point: Point;
    has name_point: Point;
    has text: str;
    has id: str;
}


node FunctionNode(BaseNode) {
    has name: str;
    has start_point: Point;
    has end_point: Point;
    has name_point: Point;
    has text: str;
    has id: str;
}


node FileNode(BaseNode) {
    has path: Path;
    has text: str;
}


node ProjectNode(BaseNode) {
    has path: str;
}


edge Calls {}


edge Defines {}


obj Point {
    has row: int;
    has column: int;
}
