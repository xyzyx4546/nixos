{
  programs.firefox.profiles."xyzyx".bookmarks.force = true;
  programs.firefox.profiles."xyzyx".bookmarks.settings = [{ toolbar = true; bookmarks = [
    {
      name = "Gaming";
      bookmarks = [
        { name = "Steam keys"; url = "https://www.keyforsteam.de"; }
      ];
    }
    {
      name = "Coding";
      bookmarks = [
        { name = "GitHub"; url = "https://github.com"; }
        { name = "GitLab"; url = "https://gitlab.com"; }
      ];
    }
    {
      name = "Proton";
      bookmarks = [
        { name = "Mail"; url = "https://mail.proton.me"; }
        { name = "Calendar"; url = "https://calendar.proton.me"; }
        { name = "Drive"; url = "https://drive.proton.me"; }
        { name = "Pass"; url = "https://pass.proton.me"; }
      ];
    }
    {
      name = "Studium";
      bookmarks = [
        { name = "Moodle"; url = "https://elearning.dhbw-stuttgart.de/moodle/my/courses.php"; }
      ];
    }
    { name = "YouTube"; url = "https://www.youtube.com/feed/subscriptions"; }
    { name = "Server"; url = "https://ehrhardt.duckdns.org"; }
  ];}];
}
