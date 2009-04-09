From: "Yongkun Wang" <yongkun-b/Nwfc8pyCekRP3n4FtbsiGn5s73+xxf@public.gmane.org>
Subject: Re: [SPAM] NILFS2 does not support swap file
Date: Thu, 9 Apr 2009 13:32:54 +0900
Message-ID: <008701c9b8cc$4016b940$c0442bc0$@iis.u-tokyo.ac.jp>
References: <007701c9b84d$f165e830$d431b890$@iis.u-tokyo.ac.jp>
	<20090409.022059.23552621.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090409.022059.23552621.ryusuke-sG5X7nlA6pw@public.gmane.org>
Content-Language: en-us
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
To: 'NILFS Users mailing list' <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hey, Ryusuke-san:

Thank you for the quick reply.

Maybe my understanding on swap is not correct. =

I wonder is it possible to have some logical-to-physical mapping like IO so
as to implement the copy-on-write for swap file on NILFS? =

I am sorry if it looks na=EFve.

Many thanks.

Best regards,
Yongkun Wang

-----Original Message-----
From: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org [mailto:users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org] On Behalf Of
Ryusuke Konishi
Sent: Thursday, April 09, 2009 2:21 AM
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org; yongkun-b/Nwfc8pyCekRP3n4FtbsiGn5s73+xxf@public.gmane.org
Subject: Re: [NILFS users] [SPAM] NILFS2 does not support swap file

Hi!
On Wed, 8 Apr 2009 22:28:45 +0900, "Yongkun Wang" wrote:
> Hey guys,
>
> I am using NILFS2, the best log-structured file system I've ever used.
> =

> But currently the NILFS2 cannot support the swap file.
> =

> I formatted the partition with nilfs2, then I create a swap file on it,
then
> mkswap swapfile, then swapon swapfile, it doesn't work.
> =

> It works well for ext2 file system.

Yes, it is not a bug but an unavoidable restriction since
supporting swapfile requires direct overwrites for the file.

Usually it is incompatible with copy-on-write based file system, and
NILFS is just such a FS.

We have to break COW nature partially if we support swapfile on the
filesystem.

OK, maybe we should describe this restriction in our FAQ page or so.

Thanks for pointed out.

Regards,
Ryusuke Konishi
_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users
