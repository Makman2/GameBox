SOURCES=src/GameBox/gamebox.vala \
        src/GameBox/Application.vala \
        src/GameBox/Resources.vala \
        src/GameBox/Game/Game.vala \
        src/GameBox/UI/ApplicationWindow.vala \
        src/GameBox/UI/Action.vala \
        src/GameBox/UI/Widgets/ActionItem.vala \
        src/GameBox/UI/Widgets/GameItem.vala \
        src/GameBox/UI/Background/Background.vala \
        src/GameBox/UI/Background/AnimatedBackground.vala \
        src/GameBox/UI/Background/ImageBackground.vala \
        src/GameBox/Data/DataStreamManager.vala \
        src/GameBox/Data/IDataStreamReadable.vala \
        src/GameBox/Data/IDataStreamWritable.vala \
        src/GameBox/Data/DataStreamReadableBase.vala \
        src/GameBox/Data/DataStreamWritableBase.vala \
        src/GameBox/Data/DataStreamManagerBase.vala

RESOURCEXML=src/resources.gresource.xml

default: debug

debug:
	valac --pkg="gtk+-3.0" --directory="./build" --basedir="./src" --debug \
          --save-temps $(SOURCES)

resources:
	mkdir -p build
	glib-compile-resources --generate --target=./build/resources.gresource \
                           --sourcedir=./src $(RESOURCEXML)

all: debug resources

