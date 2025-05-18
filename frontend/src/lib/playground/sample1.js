import * as xenpot from "../../../target/library/xenpot.js";

console.log(xenpot);

try {
  const file = xenpot.createFile({name: "Test"});
  file.addPage({name: "Foo Page"})
  const boardId = file.addArtboard({name: "Foo Board"})
  const rectId  = file.addRect({name: "Foo Rect", width:100, height: 200})

  file.addLibraryColor({color: "#fabada", opacity: 0.5})

  console.log("created board", boardId);
  console.log("created rect", rectId);

  const board = file.getShape(boardId);
  console.log("=========== BOARD =============")
  console.dir(board, {depth: 10});

  const rect = file.getShape(rectId);
  console.log("=========== RECT =============")
  console.dir(rect, {depth: 10});

  // console.dir(file.toMap(), {depth:10});
} catch (e) {
  console.log(e);
  // console.log(e.data);
}

process.exit(0);
