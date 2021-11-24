package systems;

import haxe.Timer;
import echoes.System;
import components.*;
import sprawl.components.*;
import echoes.Entity;
import sprawl.AssetRepo;
import haxe.ds.StringMap;
import nape.shape.*;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.geom.Vec2;
import kha.audio1.Audio;
import echoes.View;
import sprawl.Utils;

class GYHSystem extends System
{
    var player:View<Player>;
    var units:View<Unit>;
    public function new ()
    {
        if(Project.bgChannel == null)
            Project.bgChannel = Audio.play(AssetRepo.sounds.get("carnivalrides"),true);
        var numUnits:Int = 10;
        var numPeople:Int = 15;
        var numCollectors:Int = 10;
        var gameTime:Int = 6;
        var speed = 5;
        var sEntity = new Entity().add(
            new ScoreComp(0),
            new TimeData(["timer"=>new TimeComp(gameTime),"gameEndTimer"=>new TimeComp(gameTime+4)]));
        new Entity().add(
            new TimeData(["spawn"=>new TimeComp(Math.round(gameTime/2))]));
        
        new Entity().add(//Background
            new Position(0, 0),
            AnimComp.createAnimDataRange(0,0,Math.round(100)),
            new ImageComp("background"),
            new Scale(1,1),
            new Bounds2D(Main.WIDTH,Main.HEIGHT),
            new Visibility(),
            new RenderOffset2D(0.0, 0.0));


        var characterEcho = new Entity().add(
            new Position(Main.WIDTH /2 , Main.HEIGHT/2),
            new Velocity(0,0),
            new Player(),
            AnimComp.createAnimDataRange(7,7,Math.round(speed),"idle"),
            new ImageComp("main"),
            new AnimData([
                "idle"=>AnimComp.createAnimDataRange(7,7,Math.round(speed),"idle"),
                "run"=>AnimComp.createAnimDataRange(0,3,Math.round(speed),"run"),
                "throw"=>AnimComp.createAnimDataRange(4,6,Math.round(speed),"throw")]),
            new Scale(1,1),
            new Bounds2D(32,32),
            new Visibility(),
            new GamePad(0),
            new KeyboardState(),
            new MouseComp()
        );

    }
    @u function updateTimers(t:TimeData)
    {
        for(i in t.keys())
        {
            t.get(i).currentTime = Timer.stamp();
        }
        if(t.exists('spawn')&&t.get('spawn').endTime - t.get('spawn').currentTime <= 0)
        {
            var speed = 5;
            var numPeople = 10;
            for(i in 0...numPeople)
            {
                new Entity().add(//(.4+Math.random()/8)
                    new Position(Main.WIDTH * Math.random(), Main.PLAYAREAHEIGHT * Math.random() ),
                    new Velocity(0,0),
                    new Scale(1,1),
                    new ImageComp("peep"),
                    new Enemy(),
                    AnimComp.createAnimDataRange(0,3,Math.round(speed)),
                    new Bounds2D(32,32),
                    new AnimData([
                        "idle"=>AnimComp.createAnimDataRange(2,2,Math.round(speed)),
                        "run"=>AnimComp.createAnimDataRange(0,3,Math.round(speed))]),
                    new Visibility(),
                    new Rotation(0)//360 * Math.random())
                );
            }
            t.remove('spawn');
        }
    }
    @u function isGameDone(t:TimeData, s:ScoreComp)
    {
        if(t.get('timer').endTime - t.get('timer').currentTime <= 0)
        {
            for(i in units.entities)
            {
                if( i.get(TargetPosition) == null)
                {
                    i.add(i.get(AnimData).get('idle'));
                    i.remove(Unit);
                 }
            }
            for(i in player.entities)
            {
                i.add(i.get(AnimData).get('idle'));
                i.remove(Player);
                Audio.play(AssetRepo.sounds.get("endoflevel"));//should only happen once
            }
        }
        if(t.get('gameEndTimer').endTime - t.get('gameEndTimer').currentTime <= 0)
        {
            if(s.score > Project.highScore)
            {
                Project.highScore = s.score;
            }
            Project.lastScore = s.score;
            Project.activeState = 'menu';
            Audio.play(AssetRepo.sounds.get("endoflevel"));//should only happen once
        }
    }
}