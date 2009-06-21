From: Kristjan Eerik Kaseniit <kristjan.eerik.kaseniit-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Root file system has filled up, won't boot anymore
Date: Sun, 21 Jun 2009 19:22:33 +0300
Message-ID: <172291b30906210922i2089a389jbc9b664e6b9d7c00@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1183629438=="
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

--===============1183629438==
Content-Type: multipart/alternative; boundary=001517574498393c4f046cde2a51

--001517574498393c4f046cde2a51
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

I've installed gentoo on a NILFS2 formatted MMC SDHC card and have been
using it as my root partition. I used it just fine until after a reboot I
couldn't boot into the system (produces a kernel "BUG" with the message that
it's got an unknown opcode) and from another install I cannot chroot into it
(gives a segmentation fault), lscp doesn't finish but dies half way and both
commands won't even produce output on a second try.
The problem that caused this seems to be that the whole file system is full
- that's what all the commands tell me.

How should I proceed? Can I free up some space or do I have to make a clean
install?

I'm keeping the partition intact for a while (can boot off my harddrive) so
I can get some debug info but first I need to know what is necessary to be
helpful.
Should I post the kernel message I get when I boot?

--001517574498393c4f046cde2a51
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello,<br><br>I&#39;ve installed gentoo on a NILFS2 formatted MMC SDHC card=
 and have been using it as my root partition. I used it just fine until aft=
er a reboot I couldn&#39;t boot into the system (produces a kernel &quot;BU=
G&quot; with the message that it&#39;s got an unknown opcode) and from anot=
her install I cannot chroot into it (gives a segmentation fault), lscp does=
n&#39;t finish but dies half way and both commands won&#39;t even produce o=
utput on a second try.<br>
The problem that caused this seems to be that the whole file system is full=
 - that&#39;s what all the commands tell me.<br><br>How should I proceed? C=
an I free up some space or do I have to make a clean install?<br><br>I&#39;=
m keeping the partition intact for a while (can boot off my harddrive) so I=
 can get some debug info but first I need to know what is necessary to be h=
elpful.<br>
Should I post the kernel message I get when I boot?<br>

--001517574498393c4f046cde2a51--

--===============1183629438==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1183629438==--
