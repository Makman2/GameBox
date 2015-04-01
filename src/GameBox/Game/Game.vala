namespace GameBox.Game
{
    /**
     * Describes a game. Provides information about the game like title, cover
     * and description. Also contains data about the target platform and
     * emulation specifications.
     */
    public class Game
    {
        /**
         * Instantiates a new Game without any information.
         */
        public Game()
        {
            this.from_data("", "", "", "", "", (Gdk.Pixbuf)null);
        }

        /**
         * Instantiates a new Game.
         *
         * @param title       The game title.
         * @param platform    The game platform.
         * @param genre       The game genre.
         * @param description The game description.
         * @param path        The path to the ROM.
         * @param image       The resource path to the game image.
         * @throws Error      Thrown when loading the image from the given ID
         *                    failed.
         * @returns           The constructed Game.
         */
        public static Game new_from_resource(string title,
                                             string platform,
                                             string genre,
                                             string description,
                                             string path,
                                             string image) throws Error
        {
            return new Game.from_data(title, platform, genre, description, path,
                new Gdk.Pixbuf.from_resource(image));
        }

        /**
         * Instantiates a new Game.
         *
         * @param title       The game title.
         * @param platform    The game platform.
         * @param genre       The game genre.
         * @param description The game description.
         * @param path        The path to the ROM.
         * @param image       The game image.
         */
        public Game.from_data(string      title,
                              string      platform,
                              string      genre,
                              string      description,
                              string      path,
                              Gdk.Pixbuf? image)
        {
            this.Title = title;
            this.Platform = platform;
            this.Genre = genre;
            this.Description = description;
            this.Path = path;
            this.Image = image;
        }

        /**
         * The title of the game.
         */
        public string Title
        { get; set; }

         /**
          * The platform of the game.
          */
         public string Platform
         { get; set; }

        /**
         * The genre of the game.
         */
        public string Genre
        { get; set; }

        /**
         * The description of the game.
         */
        public string Description
        { get; set; }

        /**
         * The absolute path to the game ROM.
         */
        public string Path
        { get; set; }

        /**
         * The cover image of the game.
         */
        public Gdk.Pixbuf Image
        { get; set; }

        /**
         * Sets the image from a registered resource.
         *
         * @param resource The resource ID from where to load the image.
         * @throws Error   Thrown when loading the image from the given ID
         *                 failed.
         */
        public void SetImageFromResource(string resource) throws Error
        {
            Image = new Gdk.Pixbuf.from_resource(resource);
        }
    }
}

