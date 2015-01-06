namespace GameBox.Game
{
    /**
     * Describes a GameBox game. Provides information about the game like title,
     * cover and description. Also contains data about the target platform and
     * emulation specifications.
     */
    public class Game
    {
        /**
         * Instantiates a new Game without any information.
         */
        public Game()
        {
            this.from_data("", "", "", "", (Gdk.Pixbuf)null);
        }

        /**
         * Instantiates a new Game.
         *
         * @param title       The game title.
         * @param platform    The game platform.
         * @param description The game description.
         * @param genre       The game genre.
         * @param image       The resource path to the game image.
         */
        public Game.from_resource(string title, 
                                  string platform,
                                  string description,
                                  string genre,
                                  string image) throws Error
        {
            this.from_data(title, platform, description, genre,
                new Gdk.Pixbuf.from_resource(image));
        }

        /**
         * Instantiates a new Game.
         *
         * @param title       The game title.
         * @param platform    The game platform.
         * @param description The game description.
         * @param genre       The game genre.
         * @param image       The game image.
         */
        public Game.from_data(string     title, 
                              string     platform,
                              string     description,
                              string     genre,
                              Gdk.Pixbuf image)
        {
            this.Title = title;
            this.Platform = platform;
            this.Description = description;
            this.Genre = genre;
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
         * The description of the game.
         */
        public string Description
        { get; set; }

        /**
         * The genre of the game.
         */
        public string Genre
        { get; set; }

        /**
         * The cover image of the game.
         */
        public Gdk.Pixbuf Image
        { get; set; }
    }
}

