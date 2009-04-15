From: yong suk oh <justgn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: quering the nilfs2 garbage collection alg or schem
Date: Wed, 15 Apr 2009 14:47:01 +0900
Message-ID: <cda2f9040904142247u6e5b39e3o8bfe51d812281b13@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1713948290=="
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

--===============1713948290==
Content-Type: multipart/alternative; boundary=000e0cd2de4604ade70467917afd

--000e0cd2de4604ade70467917afd
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Dear nifls2 users and supporters

Hi

I have some question of garbage collection actually cleanerd



Could you provide an explanation of the cleanerd's(garbage collector)
algorithm and method in
cleaning the file system.



Plz let me know how is does work or some materials for me how it works


I looking for some document of nilfs2 development

thank you

--000e0cd2de4604ade70467917afd
Content-Type: text/html; charset=EUC-KR
Content-Transfer-Encoding: quoted-printable

<p style=3D"MARGIN: 0cm 0cm 0pt"><span lang=3D"EN-US" style=3D"COLOR: #2221=
15"><font face=3D"=B8=BC=C0=BA =B0=ED=B5=F1">Dear nifls2 users and supporte=
rs</font></span></p>
<p style=3D"MARGIN: 0cm 0cm 0pt"><span lang=3D"EN-US" style=3D"COLOR: #2221=
15"><font face=3D"=B8=BC=C0=BA =B0=ED=B5=F1">Hi </font></span></p>
<p style=3D"MARGIN: 0cm 0cm 0pt"><span lang=3D"EN-US" style=3D"COLOR: #2221=
15"><font face=3D"=B8=BC=C0=BA =B0=ED=B5=F1">I have some question of garbag=
e collection actually cleanerd</font></span></p>
<p style=3D"MARGIN: 0cm 0cm 0pt"><span lang=3D"EN-US" style=3D"COLOR: #2221=
15"><font face=3D"=B8=BC=C0=BA =B0=ED=B5=F1">&nbsp;</font></span></p>
<p style=3D"MARGIN: 0cm 0cm 0pt"><span lang=3D"EN-US" style=3D"COLOR: #2221=
15"><font face=3D"=B8=BC=C0=BA =B0=ED=B5=F1">Could you provide an explanati=
on of the cleanerd&#39;s(garbage collector) algorithm and method in <br>cle=
aning the file system.</font></span></p>

<p style=3D"MARGIN: 0cm 0cm 0pt"><span lang=3D"EN-US" style=3D"COLOR: #2221=
15"><font face=3D"=B8=BC=C0=BA =B0=ED=B5=F1">&nbsp;</font></span></p>
<p style=3D"MARGIN: 0cm 0cm 0pt"><span lang=3D"EN-US" style=3D"COLOR: #2221=
15"><font face=3D"=B8=BC=C0=BA =B0=ED=B5=F1">Plz let me know how is does wo=
rk or some materials for me how it works</font></span></p>
<p style=3D"MARGIN: 0cm 0cm 0pt"><span lang=3D"EN-US" style=3D"COLOR: #2221=
15"><font face=3D"=B8=BC=C0=BA =B0=ED=B5=F1">&nbsp;</font></span></p>
<div style=3D"MARGIN: 0cm 0cm 0pt"><span lang=3D"EN-US" style=3D"COLOR: #22=
2115"><font face=3D"=B8=BC=C0=BA =B0=ED=B5=F1">I looking for some document =
of nilfs2 development</font></span></div>
<div style=3D"MARGIN: 0cm 0cm 0pt"><span lang=3D"EN-US" style=3D"COLOR: #22=
2115"><font face=3D"=B8=BC=C0=BA =B0=ED=B5=F1"></font></span>&nbsp;</div>
<div style=3D"MARGIN: 0cm 0cm 0pt"><span lang=3D"EN-US" style=3D"COLOR: #22=
2115"><font face=3D"=B8=BC=C0=BA =B0=ED=B5=F1">thank you</font></span></div=
>
<div style=3D"MARGIN: 0cm 0cm 0pt"><span lang=3D"EN-US" style=3D"COLOR: #22=
2115"><font face=3D"=B8=BC=C0=BA =B0=ED=B5=F1"></font></span>&nbsp;</div>
<p style=3D"MARGIN: 0cm 0cm 0pt"><span lang=3D"EN-US"><font face=3D"=B8=BC=
=C0=BA =B0=ED=B5=F1">&nbsp;</font></span></p>

--000e0cd2de4604ade70467917afd--

--===============1713948290==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1713948290==--
