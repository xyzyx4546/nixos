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
          (folder "Gaming" [
            (item "Steam keys" "https://www.keyforsteam.de")
          ])
          (folder "Proton" [
            (item "Mail" "https://mail.proton.me")
            (item "Calendar" "https://calendar.proton.me")
            (item "Drive" "https://drive.proton.me")
            (item "Pass" "https://pass.proton.me")
          ])
          (folder "Studium" [
            (item "Moodle" "https://elearning.dhbw-stuttgart.de/moodle/my/courses.php")
          ])
          (item "GitHub" "https://github.com")
          (item "YouTube" "https://www.youtube.com/feed/subscriptions")
          (item "Server" "https://ehrhardt.duckdns.org")
        ];
      }
    ];
  };
}
