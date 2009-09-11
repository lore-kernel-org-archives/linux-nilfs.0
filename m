From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: GTK version of lssu
Date: Fri, 11 Sep 2009 19:58:00 +0900 (JST)
Message-ID: <20090911.195800.36241798.ryusuke@osrg.net>
References: <debc30fc0908291443l2ef61975rcaa3899e08722eee@mail.gmail.com>
	<debc30fc0908311949t3146aebep4343a73cdc3a9371@mail.gmail.com>
	<87iqfrbahx.wl%jir@sekiba.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <87iqfrbahx.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org, =?iso-8859-1?Q?J=E9r=F4me?= Poulin <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi J=E9r=F4me,
On Thu, 10 Sep 2009 15:05:14 +0900, Jiro SEKIBA wrote:
> Hi,
> =

> At Mon, 31 Aug 2009 22:49:55 -0400,
> J=E9r=F4me Poulin wrote:
> > =

> > [1  <multipart/alternative (7bit)>]
> > [1.1  <text/plain; ISO-8859-1 (quoted-printable)>]
> > =

> > [1.2  <text/html; ISO-8859-1 (quoted-printable)>]
> > I just wanted to say that the program is now stable, and has some fine-=
tunning
> > available in the header of the file, just edit with a text editor. It c=
an also
> > now be resized correctly, has a different method of coloring has filled
> > segments and such. You can give me feedback if you tried it, and for yo=
ur own
> > privacy I will attach the file to this message, but I like to see downl=
oads in
> > my Apache access log too :)
> > http://ticpu.net:8080/~jerome/lssu-gtk.py
> =

> I've tried your application.  It looks nice :-).
> Especially, when garbage collector is working! =

> it updates display and keep track the current segment usages, cool!
> =

> There are two comments for further improvement.
> =

> - It would be greate to have header to explain which colors shows which s=
tate.
> - It's nice to be able to specify the device, =

>   and shows the device and mount point in the header.
> =

> Anyway it's nice to see the disk usage in graphical like this way.
> =

> Thanks!
> =

> regards,
> -- =

> Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>

I belatedly tried this tool to view the state of my nilfs partion
under testing.  Well, it's pretty good.

Previously, I used to do "watch lssu" in another terminal.  lssu-gtk
is helpful to clean up my debug environment neatly ;)

Thank you for posting!

Ryusuke Konishi
