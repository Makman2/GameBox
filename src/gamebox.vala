// This file is part of GameBox. License: GPL3

/**
 * Entry point for this application.
 * @param args Input arguments.
 * @returns    0 means program exited without errors, else errors
 *             occured during exit.
 */
public int main(string[] args)
{
    GameBox.Application app = new GameBox.Application();
    return app.run(args);
}
