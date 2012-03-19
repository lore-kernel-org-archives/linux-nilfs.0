From: =?iso-8859-1?Q?Sven-G=F6ran_Bergh?= <svengbergh-nilfs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: RE: nilfs_cleanerd Function not implemented
Date: Mon, 19 Mar 2012 10:53:47 -0700 (PDT)
Message-ID: <1332179627.27070.YahooMailNeo@web161904.mail.bf1.yahoo.com>
References: <1331907699.90830.YahooMailNeo@web161901.mail.bf1.yahoo.com> <20120317.204343.93460664.ryusuke@osrg.net> <20120317.225320.67906283.ryusuke@osrg.net> <20120318.021740.212402053.ryusuke@osrg.net> <1332145146.39316.YahooMailNeo@web161904.mail.bf1.yahoo.com>
Reply-To: =?iso-8859-1?Q?Sven-G=F6ran_Bergh?= <svengbergh-nilfs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1332179627; bh=xYjmfQwxG1BygGak3yo+N3i6qxVp1rOQDiVIpsQnl08=; h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding; b=geIa4GznsnAlHYS+Tl7lr6pdgkC8dY010sVXCUwrY6HQDzu9qR4tN2W5kugjCm6LgPUVsuU31NDdeyBuombs9c7EVLsaMMbMI1Znu60PuKAJsFGwhtv57DyI1LtdZ0VPprexpIVvwU0gwx3szPIBwtv/rTnd1h9+g/gtBP++EfE=
In-Reply-To: <1332145146.39316.YahooMailNeo-/W4/QBBOCLLK0anN2EpufZEhsgyP+Z75VpNB7YpNyf8@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: "linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi again,


Just reporting back my results...

>>  I read the source code of sem_open() in glibc and found that

>>  sem_open() fails if there is no tmpfs (former shm fs) mount in the
>>  system.
>>=20
>>  According to your strace log, your /dev/shm is mounted with "ramfs"
>>  whose magic number is 0x858458f6.=A0 This looks the cause of the er=
ror.
>>=20
>>> =A0 statfs("/dev/shm", {f_type=3D0x858458f6, f_bsize=3D4096, f_bloc=
ks=3D0,
>>> =A0 f_bfree=3D0, f_bavail=3D0, f_files=3D0, f_ffree=3D0, f_fsid=3D{=
0, 0},
>>> =A0 f_namelen=3D255, f_frsize=3D4096}) =3D 0
>>=20
>>  Try following kernel configs to enable tmpfs and mount it to
>>  /dev/shm instead of using ramfs.
>>=20
>>  - CONFIG_SHMEM
>>  =A0 =A0 =A0 Generic setup ->
>>  =A0 =A0 =A0 =A0 Configure standard kernel features (expert users) -=
>
>>  =A0 =A0 =A0 =A0 =A0 Use full shmem filesystem
>>=20
>>  - CONFIG_TMPFS
>>  =A0 =A0 =A0 File systems ->
>>  =A0 =A0 =A0 =A0 Pseudo filesystems ->
>>  =A0 =A0 =A0 =A0 =A0 Tmpfs virtual memory file system support (forme=
r shm fs)
>=20
> You are right. I was using ramfs and when I tried with CONFIG_SHMEM
> I still used ramfs, so right now I am compiling a new kernel with
> both CONFIG_SHMEM and CONFIG_TMPFS. I will report my results when
> I have tried the new kernel.

That did it! Both CONFIG_SHMEM _and_ CONFIG_TMPFS are needed.
I now have a new firmware image for my project and nilfs is
working as expected.

Due to the nature of the project, nilfs_cleanerd is not started when
the FS is mounted (in the initramfs). Instead it is supervised with
runsv(dir), so I start nilfs_cleanerd with -n to keep it from forking.
I hope this is the proper way of running nilfs_cleanerd under a
supervisor?!?

Thanks again!
/S-G

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
