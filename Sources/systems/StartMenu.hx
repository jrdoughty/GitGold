package systems;

#if js 
import js.Browser;
#else
import sys.io.File;
#end
import sprawl.serialization.WorkflowData;
import echoes.System;
import echoes.Entity;
import components.*;
import sprawl.components.*;
import echoes.Workflow;
import sprawl.Utils;
import sprawl.AssetRepo;
import haxe.ds.StringMap;


class StartMenu extends System
{
    public function new() {
        //seri.unserialize(b); 
        new Entity().add(//Background
            new Position(0, 0),
            new ImageComp("menubackground"),
            new Scale(Main.WIDTH/AssetRepo.images.get("menubackground").width,Main.HEIGHT/AssetRepo.images.get("menubackground").height),
            new Bounds2D(AssetRepo.images.get("menubackground").width,AssetRepo.images.get("menubackground").height),
            new Visibility(),
            new RenderOffset2D(0.0, 0.0));
        new Entity().add(
            new Position(Main.WIDTH /2 , Main.HEIGHT/2),
            new ImageComp("button"),
            new AnimData(new StringMap()),
            new Scale(10,5),
            new Bounds2D(48,16),
            new Visibility(),
            new ButtonComp('play'),
            new GamePad(0),
            new KeyboardState(),
            new MouseComp()
        );
        new Entity().add(
            new Position(Main.WIDTH /2, Main.HEIGHT/2 + 96),
            new ImageComp("button"),
            new AnimData(new StringMap()),
            new Scale(10,5),
            new Bounds2D(48,16),
            new Visibility(.05,true),
            new ButtonComp('credits'),
            new GamePad(0),
            new KeyboardState(),
            new MouseComp()
        );
        new Entity().add(
            new Position(Main.WIDTH /2-145, Main.HEIGHT/4),
            new Scale(10,30),
            new Visibility(),
            new TextComp("Git Gold","_8bitlim",kha.Color.Orange)
        );
        new Entity().add(
            new Position(Main.WIDTH /2-140, Main.HEIGHT/4),
            new Scale(10,28),
            new Visibility(),
            new TextComp("Git Gold","_8bitlim",kha.Color.Yellow)
        );
        if(Project.highScore>0)
        {
            new Entity().add(
                new Position(Main.WIDTH /2-145, Main.HEIGHT/4*3+27),
                new Scale(10,15),
                new Visibility(),
                new TextComp("High Score " + Project.highScore,"_8bitlim",kha.Color.Yellow)
            );
            new Entity().add(
                new Position(Main.WIDTH /2-145, Main.HEIGHT/4*3+127),
                new Scale(10,15),
                new Visibility(),
                new TextComp("Last Score " + Project.lastScore,"_8bitlim",kha.Color.Yellow)
            );
        }
        /*
        #if js
        Browser.getLocalStorage().setItem('test.txt',bs.get('startmenu_txt').toString());
        Workflow.load(Browser.getLocalStorage().getItem('test.txt'));
        #else
        var s = new hxbit.Serializer();
        File.saveBytes('test.sav', haxe.io.Bytes.ofString(bs.get('startmenu_txt').toString()));
        Workflow.load(File.getBytes('test.sav').toString());
        #end
        */
    }

    @u public function mouseBtnUpdate (m:MouseComp, b:ButtonComp, p:Position, wh:Bounds2D, s:Scale)
    {
        var mPos = new Position(m.x,m.y);
        if(m.mousePressed[0] && Utils.pointInAABBTestWithScaleCentered(mPos,p,wh,s))
        {
            //trace(b.tag+' down');
        }
        else if(m.mouseUp[0] && Utils.pointInAABBTestWithScaleCentered(mPos,p,wh,s))
        {
            Project.activeState = b.tag;
        }
        else if(Utils.pointInAABBTestWithScaleCentered(mPos,p,wh,s))
        {
            //over            
        }
        else 
        {
            //out 
        }
    }


}