import { Path, CatmullRomCurve3, Vector3, Vector2, Shape, ShapePath, BufferGeometry, ExtrudeBufferGeometry } from "./../lib/three/three.module.js";
import { BufferGeometryUtils } from "./../lib/three/utils/BufferGeometryUtils.js";

import { mod } from "./math.js";

const makeSplinePath = (pts, closed) => {
  const spline = new Path();
  spline.curves.push(
    new CatmullRomCurve3(
      pts.map(({ x, y }) => new Vector3(x, y)),
      closed
    )
  );

  return spline;
};

const makeCirclePath = (x, y, radius, aClockwise = true) => {
  const circle = new Path();
  circle.absarc(x, y, radius, 0, Math.PI * 2, aClockwise);
  return circle;
};

const makeRectanglePath = (x, y, width, height) =>
  makePolygonPath([new Vector2(x, y), new Vector2(x + width, y), new Vector2(x + width, y + height), new Vector2(x, y + height)]);

const makePolygonPath = points => new Shape(points);

const expandShapePath = (shapePath, thickness, divisions) => {
  const expansion = new ShapePath();
  shapePath.subPaths.forEach(subPath => expansion.subPaths.push(new Path(getOffsetPoints(subPath, thickness / 2, 0, 1, 1 / divisions))));
  return expansion;
};

const getOffsetPoint = (source, t, offset) => {
  t = mod(t, 1);
  // These are Vector3, but we need a Vector2
  const tangent = source.getTangent(t);
  const pos = source.getPoint(t);
  return new Vector2(pos.x - tangent.y * offset, pos.y + tangent.x * offset);
};

const getOffsetPoints = (source, offset, start, end, spacing) => {
  const points = [getOffsetPoint(source, start, offset)];
  if (spacing > 0) {
    let i = Math.ceil(start / spacing) * spacing;
    if (i == start) i += spacing;
    for (i; i < end; i += spacing) {
      points.push(getOffsetPoint(source, i, offset));
    }
  }
  points.push(getOffsetPoint(source, end, offset));
  return points;
};

const makeGeometry = (shapePath, depth, curveSegments) =>
  new ExtrudeBufferGeometry(shapePath.toShapes(false, false), {
    depth: Math.max(Math.abs(depth), 0.0000001),
    curveSegments,
    bevelEnabled: false
  });

const mergeGeometries = geometries => {
  if (geometries.length == 0) {
    return new BufferGeometry();
  }

  const numIndexed = geometries.filter(geometry => geometry.index != null).length;
  if (numIndexed > 0 && numIndexed < geometries.length) {
    throw new Error("You can't merge indexed and non-indexed buffer geometries.");
  }

  return BufferGeometryUtils.mergeBufferGeometries(geometries);
};

const mergeShapePaths = (shapePath, other) => {
  other.subPaths.forEach(path => shapePath.subPaths.push(path.clone()));
};

const addPath = (shapePath, path) => {
  shapePath.subPaths.push(path.clone());
};

export { addPath, makeGeometry, makeCirclePath, getOffsetPoints, mergeGeometries, makePolygonPath, makeRectanglePath, makeSplinePath, expandShapePath };
