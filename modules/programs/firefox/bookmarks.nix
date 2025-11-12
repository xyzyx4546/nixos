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
            (item "Rapla" "https://rapla.dhbw.de/rapla/calendar?key=5rBgzE8vgPbhgXiJyxx-0UCbHyoc66RNQpI_KSJSTzwKhmhw9TmBpAxkTFcX3ekGZvmMIfKjixjI4sqYWjh8QSKk6Roj-wReI77MwBFOLM16mUJlJTz7JJ4o62NFiY5fGryjvwt1kpad5g93Dkdn0A&salt=-231759520")
            (item "E-Mail" "https://lehre-webmail.dhbw-stuttgart.de/roundcubemail")
          ])
          (item "GitHub" "https://github.com")
          (item "Nextcloud" "https://fam-ehrhardt.de")
        ];
      }
    ];
  };
}
