@echo off
rem Script created by Samoylov Nikolay <github.com/tarampampam> # 2014
rem Version 0.1.1
set BLOCK_SITE_REDIRECT=127.0.0.1
set HOSTS_FILE="%SystemRoot%\system32\drivers\etc\hosts"

goto:checkPermissions
:begin

echo. >> %HOSTS_FILE%
echo ## Block installed : %date% at %time% >> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% www.facebook.com facebook.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% vk.com vkontakte.ru www.vk.com www.vkontakte.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% odnoklassniki.ru odnoklasniki.ru www.odnoklassniki.ru www.odnoklasniki.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% twitter.com www.twitter.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% www.linkedin.com linkedin.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% myspace.com www.myspace.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% orkut.com www.orkut.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% twitpic.com www.twitpic.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% yfrog.com www.yfrog.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% blogger.com www.blogger.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% wordpress.com wordpress.org www.wordpress.com www.wordpress.org>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% tumblr.com www.tumblr.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% narod.ru www.narod.ru narod.yandex.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% www.ucoz.ru ucoz.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% liveinternet.ru www.liveinternet.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% www.livejournal.com livejournal.com www.livejournal.ru livejournal.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% diary.ru www.diary.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% www.youtube.com youtube.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% flickr.com www.flickr.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% www.imdb.com imdb.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% vimeo.com www.vimeo.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% zaycev.net www.zaycev.net>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% www.last.fm last.fm>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% www.rutube.ru rutube.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% bash.org.ru www.bash.org.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% www.zadolba.li zadolba.li>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% ithappens.ru www.ithappens.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% intv.ru www.intv.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% www.imageshack.us imageshack.us>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% ag.ru www.ag.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% kinopoisk.ru www.kinopoisk.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% dailymotion.com www.dailymotion.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% imgur.com www.imgur.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% msn.com www.msn.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% rbc.ru www.rbc.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% habr.ru habrahabr.ru www.habr.ru www.habrahabr.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% bbc.co.uk www.bbc.co.uk bbc.com www.bbc.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% cnn.com www.cnn.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% reddit.com www.reddit.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% www.digg.com digg.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% liga.net www.liga.net>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% lenta.ru www.lenta.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% www.korrespondent.net korrespondent.net>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% espn.com www.espn.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% cnet.com www.cnet.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% nytimes.com www.nytimes.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% nnm.ru www.nnm.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% km.ru www.km.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% kp.ru www.kp.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% sport-express.ru www.sport-express.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% championat.com championat.ru www.championat.com www.championat.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% www.tut.by tut.by>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% gazeta.ru www.gazeta.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% foxnews.com www.foxnews.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% addictinggames.com www.addictinggames.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% www.bored.com bored.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% games.mail.ru www.games.mail.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% ask.com www.ask.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% auto.ru www.auto.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% ehow.com www.ehow.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% zvezdi.ru www.zvezdi.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% loveplanet.ru www.loveplanet.ru>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% ukr.net www.ukr.net>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% yelp.com www.yelp.com>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% rapidshare.com rapidshare.de www.rapidshare.com www.rapidshare.de>> %HOSTS_FILE%
echo %BLOCK_SITE_REDIRECT% stackoverflow.com www.stackoverflow.com>> %HOSTS_FILE%
echo. >> %HOSTS_FILE%

echo [Info] Sites blocked, %HOSTS_FILE% edited

goto:end

:log
  echo [%time%] %~1
  exit /b

:checkPermissions
  net session >nul 2>&1
  if %errorLevel%==0 (
      goto:begin
  ) else (
      call:log "[Failure] Need administrative permissions"
      goto:end
  )
  exit /b
  
:end
  echo. && echo Exit after 5 seconds && timeout /t 5 > nul
  echo on
  @exit
