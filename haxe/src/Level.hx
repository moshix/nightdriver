import js.three.Group;
import js.three.Path;
import js.three.ShapePath;
import js.three.Vector2;
import js.three.Color;

import drivey.ThreeUtils.*;

enum RoadLineStyle {
    SOLID;
    DASH(on:Float, off:Float);
}

class Level
{
    static var DASH_ON = Math.NaN;
    static var DASH_OFF = Math.NaN;

    public var world(default, null):Group;
    public var roadPath(default, null):RoadPath;
    public var name(default, null):String;
    // TODO: wall collider ShapePath

    public var ground(default, null):Float = 0;
    public var skyLow(default, null):Float = 0;
    public var skyHigh(default, null):Float = 0;
    public var skyGradient(default, null):Float = 0;
    public var tint(default, null):Color;

    var heightScale:Float = 1;

    public function new() {
        world = new Group();
        roadPath = makeRoadPath();
        build();
        finish();
    }

    function build() {}

    function drawRoadLine(roadPath:RoadPath, shapePath:ShapePath, xPos:Float, width:Float, style:RoadLineStyle, start:Float, end:Float, divisions:UInt):ShapePath {

        if (start == end) return shapePath;

        switch (style) {
            case DASH(on, off) :
                var dashStart = start;
                var dashSpan = (on + off) / roadPath.length;
                var dashLength = dashSpan * on / (on + off);
                while (dashStart < end) {
                    drawRoadLine(roadPath, shapePath, xPos, width, SOLID, dashStart, Math.min(end, dashStart + dashLength), divisions);
                    dashStart += dashSpan;
                }
            case SOLID :
                width = Math.abs(width);
                var outsideOffset = xPos - width / 2;
                var insideOffset = xPos + width / 2;

                var outsidePoints:Array<Vector2> = [];
                var insidePoints:Array<Vector2> = [];
                var coverage = end - start;
                var coveredDivisions = Std.int(Math.ceil(divisions * coverage / roadPath.length));
                var diff = 1 / divisions;
                var i = start;
                while (i < end) {
                    outsidePoints.push(cast getExtrudedPointAt(roadPath.curve, i, outsideOffset));
                    insidePoints.push(cast getExtrudedPointAt(roadPath.curve, i, insideOffset));
                    i += diff;
                }
                outsidePoints.push(cast getExtrudedPointAt(roadPath.curve, end, outsideOffset));
                insidePoints.push(cast getExtrudedPointAt(roadPath.curve, end, insideOffset));
                outsidePoints.reverse();

                if (start == 0 && end == 1) {
                    shapePath.subPaths.push(makePolygonPath(outsidePoints));
                    shapePath.subPaths.push(makePolygonPath(insidePoints));
                } else {
                    shapePath.subPaths.push(makePolygonPath(outsidePoints.concat(insidePoints)));
                }
        }

        return shapePath;
    }

    function finish() {
        world.scale.z *= heightScale;
    }

    function makeRoadPath() {

        var n = 16;
        var points = [];
        var minX:Float = Math.POSITIVE_INFINITY;
        var maxX:Float = Math.NEGATIVE_INFINITY;
        var minY:Float = Math.POSITIVE_INFINITY;
        var maxY:Float = Math.NEGATIVE_INFINITY;
        for (i in 0...n)
        {
            var theta:Float = i * Math.PI * 2 / n;
            var radius = Math.random() + 5;
            var point = new Vector2(Math.cos(theta) * -radius, Math.sin(theta) * radius);
            points.push(point);
            minX = Math.min(minX, point.x);
            maxX = Math.max(maxX, point.x);
            minY = Math.min(minY, point.y);
            maxY = Math.max(maxY, point.y);
        }
        var centerX = maxX - minX;
        var centerY = maxY - minY;
        for (point in points) {
            point.x -= centerX;
            point.y -= centerY;
            point.y *= centerX / centerY;
            point.x *= 400;
            point.y *= 400;
        }

        return new RoadPath(points);
    }
}
