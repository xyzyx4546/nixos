let
  profile = "xyzyx";

  item = name: url: {
    inherit name;
    inherit url;
  };

  folder = name: bookmarks: {
    inherit name;
    inherit bookmarks;
  };
in {
  programs.firefox.profiles.${profile}.bookmarks = {
    force = true;
    settings = [
      {
        toolbar = true;
        bookmarks = [
          (folder "Studium" [
            (item "Moodle" "https://elearning.dhbw-stuttgart.de/moodle/my/courses.php")
            (item "Dualis" "https://dualis.dhbw.de/")
          ])
          (item "GitHub" "https://github.com")
          (item "YouTube" "https://www.youtube.com/feed/subscriptions")
          (item "Server" "https://ehrhardt.duckdns.org")
        ];
      }
    ];
  };
}
