package drivey.levels;

import drivey.Utils.*;

class DeepDarkNight extends Level {
    override function build() {
        name = 'The Deep Dark Night';
        tint = 0.7;
        ground = 0;
        skyHigh = 0;
        skyLow = 0;
        var lines:Color = 0.75;
        roadPath.scale(2, 2); // roadForm.applyScale(2, 2);
        var layer = addLayer('nightLines');
        layer.rgb = lines;
        layer.height = 0;

        layer.merge(drawRoadLine(new Form('nightLine1'), roadPath, 0, 0.2, 4, 10));
        layer.merge(drawRoadLine(new Form('nightLine2'), roadPath, -3, 0.15, 30, 2));
        layer.merge(drawRoadLine(new Form('nightLine3'), roadPath, 3, 0.15, 30, 2));

        var sh = addLayer('nightPosts');
        sh.rgb = lines;
        sh.height = 0.6;
        sh.extrude = 1;
        sh.merge(drawRoadLine(new Form('nightPost1'), roadPath, -6, 0.2, 0.2, 50));
        sh.merge(drawRoadLine(new Form('nightPost2'), roadPath, 6, 0.2, 0.2, 50));

        // scr.setTint(0, 0.6, 1);
    }
}
