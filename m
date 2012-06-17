From: Ivan Shmakov <oneingray-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NILFS2 under stress
Date: Sun, 17 Jun 2012 19:55:05 +0700
Message-ID: <86vciqrtcm.fsf@gray.siamics.net>
References: <CAPLqH6x7OCXS95w7-J+DLdiVkKAuKm=-8ofGwL-rcC19Z679bw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

>>>>> Zavi Zavi writes:

 > I've been experimenting with NILFS2 on a 8GB USB stick.  I repeatedl=
y
 > created and deleted a 128MB file. After about 60 attempts, the disk
 > got 100% full, and would not respond anymore.

	I've tried to install a Debian Wheezy instance onto an 8 GiB
	logical volume via debootstrap(8) from Debian Squeeze (Linux
	2.6.32-5-amd64, nilfs-tools 2.0.18-2) and have witnessed pretty
	much the same behavior.

 > So I tried repeating this setup after changing the GC settings to be
 > much more agressive GC policy

 > protection_period       0

[=E2=80=A6]

	I've restarted nilfs_cleanerd(8) with the protection period set
	to only 60 seconds (see below; the rest of the configuration is
	as per the Debian defaults), and the free space began to rise,
	albeit somewhat slowly (around a few MiB's per second), until it
	reached 1.7 GiB, when it's stopped.

	(I guess that it's quite normal, though I'm yet to become
	familiar with NILFS2.)

# nilfs_cleanerd -p 60 \
      /dev/mapper/vgXXX-host--2012--06--17.chroot \
      /srv/chroot/2012-06-17=20

--=20
=46SF associate member #7257

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
