From: "Peter Smith" <smithpdo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: mkcp does not follow symbolic links
Date: Tue, 4 Nov 2008 11:16:01 +0200
Message-ID: <474dca090811040116o5f2d1d05ka9bdeabef4f8c672@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0935079709=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Mime-version: 1.0
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

--===============0935079709==
Content-Type: multipart/alternative; 
	boundary="----=_Part_69672_19805398.1225790161257"

------=_Part_69672_19805398.1225790161257
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

It seems that mkcp does not follow symbolic links

The command
mkcp -s /dev/disk/by-id/usb-ST325031_5RY1_888888888888-0:0-part3
gives this message:
mkcp: /dev/disk/by-id/usb-ST325031_5RY1_888888888888-0:0-part3: cannot open
NILFS

I use the 'disk/by-id' path because it is stable, despite
removing/installing other drives

I solve the problem in my code by converting the symbolic link to a real
path such as /dev/sde3
and then mkcp works as expected.

I mention this because it is a potential trap for the unwary.

My environment is Suse Linux 10.3

regards,
Peter


-- 
This is Linux land. On quiet nights you can hear the Windows machines
rebooting.

------=_Part_69672_19805398.1225790161257
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi<br><br>It seems that mkcp does not follow symbolic links<br><br>The command <br>mkcp -s /dev/disk/by-id/usb-ST325031_5RY1_888888888888-0:0-part3<br>gives this message:<br>mkcp: /dev/disk/by-id/usb-ST325031_5RY1_888888888888-0:0-part3: cannot open NILFS<br>
<br>I use the &#39;disk/by-id&#39; path because it is stable, despite removing/installing other drives<br><br>I solve the problem in my code by converting the symbolic link to a real path such as /dev/sde3<br>and then mkcp works as expected.<br>
<br>I mention this because it is a potential trap for the unwary.<br><br>My environment is Suse Linux 10.3<br><br>regards,<br>Peter<br><br clear="all"><br>-- <br>This is Linux land. On quiet nights you can hear the Windows machines rebooting.<br>


------=_Part_69672_19805398.1225790161257--

--===============0935079709==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0935079709==--
