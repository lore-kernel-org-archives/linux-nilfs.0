From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NILFS for a "chroot": a kind of a work-around
Date: Sun, 15 Jul 2012 01:07:54 +0400
Message-ID: <7292C0D8-99A6-4A9E-A1B6-976138550FFA@dubeyko.com>
References: <86zk72xq2g.fsf@gray.siamics.net>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=Dhp2Zl7mQsT6PWPYejblOal5GspTNteMYOqPc/6GoFM=;
	b=nYuh5iBGFSp4I2EhAMk1ly/+1Hxs0AOauUhXOaq6BWEbR/2hPwTZXj+7A86MKnKqjznUvXVwIrXXv9tXgj9tjSNzCctPQGyciLXgN8OelJHhKqtpOCD82JGsIc4FLKqH;
In-Reply-To: <86zk72xq2g.fsf-Sxm0eyAyORm7AG94EA9mQA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Ivan Shmakov <oneingray-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

As I know, checkpointing is a fundamental technique of the NILFS. It is=
 possible to imagine checkpointing as an act of final placing of file s=
ystem blocks on disk storage. Another filesystems also writing on disk =
but, usually, without possibility to keep history of file system operat=
ions and manage by history. Checkpoint in NILFS is natural possibility =
to prevent from file system inconsistency and failure by means of Copy-=
On-Write policy. Of course, checkpoints keep duplicates of  metadata an=
d data information but obsolete checkpoints can be deleted by nilfs_cle=
anerd. So, from my point of view, your approach is trying to overcome t=
he main goal of the NILFS.

What about reliability in your approach? Everything can occur during op=
erations under tmpfs partition (for example, sudden power off).

I think that it doesn't exist ideal file system that can be best in all=
 possible workloads. So, if you have some use-case or workload in that =
NILFS is not so good, maybe it will be better to use another file syste=
m?

With the best regards,
Vyacheslav Dubeyko.

On Jul 14, 2012, at 8:31 PM, Ivan Shmakov wrote:

> 	It was mentioned recently [1] that NILFS doesn=92t handle frequent
> 	file =93creation-removal=94 cycles well, and these are typical to,
> 	in particular, # apt-get install (upgrade) operation.
>=20
> 	I=92m currently using NILFS for =93root=94 filesystems of a couple o=
f
> 	chrooted environments I use to test new software, which implies
> 	that Debian packages are installed and upgraded quite often.
>=20
> 	As a work-around, I=92ve made a copy of the filesystem on tmpfs,
> 	and run # apt-get from there, like:
>=20
> # chroot /tmp/debian.UvYusUaj apt-get upgrade=20
>=20
> 	Then, I propagate the changes back to the original NILFS root
> 	with rsync(1), like:
>=20
> # rsync -x -a -v -rlOtH \
>      -b --suffix=3D.~$(date +%s)~ --backup-dir=3D.rsync-backup \
>      --exclude=3D/.rsync-backup/ --exclude=3D/.nilfs \
>      --delete \
>      -- /tmp/debian.UvYusUaj/ /srv/chroot/2012-07-06-unsafe/=20
>=20
> 	This obviously results in much less checkpoints, too, and thus,
> 	AIUI, less overall stress to the filesystem.
>=20
> 	(Sometimes, I=92d also chcp(8) the latest of the newly-made
> 	checpoints into a snapshot.)
>=20
> [1] http://permalink.gmane.org/gmane.comp.file-systems.nilfs.user/239=
7
>=20
> --=20
> FSF associate member #7257	http://sf-day.org/
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs=
" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" =
in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
