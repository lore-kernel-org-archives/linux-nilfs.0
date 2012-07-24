From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: read error on superblock
Date: Tue, 24 Jul 2012 10:26:37 +0400
Message-ID: <1343111197.1982.32.camel@slavad-ubuntu-11>
References: <2948186.vfdzh15lNi@coil>
	 <20120723.201918.94868195.konishi.ryusuke@lab.ntt.co.jp>
	 <8066200.UhSxO3eimj@blitz>
	 <20120724.090604.40913934.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Content-Transfer-Encoding:Mime-Version:Message-ID:Date:Content-Type:References:In-Reply-To:Cc:To:From:Subject; bh=xl+UMonVibmK2GLML4TreMfeApW7qnttL+1tts87r7o=;
	b=Vt89ZTQCvw5624Z/dKKGAvcOpvdf6Jd2mkIl1zZCWbMke8UimiaXKxQEns6V+HvZIsaex5glWfLLpjsUzLfv6sqYXWw9E0pP3FL275WOFYpEDGE2FKMN9LEYE7dM1sCp;
In-Reply-To: <20120724.090604.40913934.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: dexen deVries <dexen.devries-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Tue, 2012-07-24 at 09:06 +0900, Ryusuke Konishi wrote:
> On Mon, 23 Jul 2012 20:24:10 +0200, dexen deVries wrote:
> > Hi again,
> > 
> > 
> > I've copied the whole filesystem elsewhere (to a file) with `ddrescue'. It found 
> > one damaged area on the drive, but apparently neither at start nor at the end 
> > of partition.
> > 
> > The FS on the drive was marked as `dirty' (requiring recovery upon mount). My 
> > guess is that kernel attempted recovery, and gave up upon read error.
> > 
> > Unfortunately, the `norecovery' option did not help with the drive; it only 
> > helped once i've moved whole FS to file.
> > 
> > 
> > Log from ddrescue:
> > 
> > 
> > # Rescue Logfile. Created by GNU ddrescue version 1.14
> > # Command line: ddrescue /dev/sdc3 sda3 sda3.log
> > # current_pos  current_status
> > 0x149E0CCC00     +
> > #      pos        size  status
> > 0x00000000  0x149E0CC000  +
> > 0x149E0CC000  0x00001000  -
> > 0x149E0CD000  0x11220D3000  +
> > 
> > 
> > my understanding is, the following line describes the damaged area, format: 
> > start length status-marker (`-' for error)
> > 0x149E0CC000  0x00001000  -
> > 
> > 
> > Once the FS was copied to a file, it mounted correctly:
> > # mount -o ro,loop,norecovery ./sda3.img ./some-mountpoint 
> > 
> > 
> > My gripe with current (linux-3.5.0) NILFS2 driver is that I couldn't tell it 
> > to ignore read errors and thus force it to mount the filesystem.
> 
> Good point.  The current recovery logic is intentionally implemented
> so that it aborts when having met an I/O error.

I am afraid that it is not so good from the end user point of view.

First of all, the message "mount: /dev/sda3: can't read superblock" can
confuse user. The reason is bad sectors inside the volume but user is
informed about impossibility to read superblock.

Secondly, it is possible situation when it really needs to use a volume
in the case of presence of bad sectors. And I think that users can
expect such NILFS behavior because of declared reliability.

Unfortunately, as I can understand, NILFS hasn't bad blocks table and
can't process situation of bad blocks presence on volume correctly. It
means that NILFS interprets bad blocks as exceptional case. But from my
point of view, it makes sense to interpret bad blocks as usual thing and
try to work in the presence of ones. For example, fsck potentially can
check NILFS volume on bad blocks presence, construct bad blocks table
and save it on the volume.

I suggest to add "virtual" special file for bad blocks description. It
can be described by inode in ifile and all bad blocks can be described
in DAT file as parts of this "virtual" special file. So, as a result,
NILFS file system driver will have bad blocks table which can be a basis
for excluding bad blocks from operation and trying to survive in the not
good device environment.

What do you think about such idea?

With the best regards,
Vyacheslav Dubeyko.

> 
> This treatment should not be applied at least if the norecovery option
> is specified.
> 
> Thanks,
> Ryusuke Konishi
> 
> > Ony after I've 
> > moved some 160GB of FS to a file (that's a bit tedious :P) it opened the FS 
> > just fine.
> > 
> > 
> > Cheers,
> > -- 
> > dexen deVries
> > 
> > 1972 - Dennis Ritchie invents a powerful gun that shoots both forward and 
> > backward simultaneously. Not satisfied with the number of deaths and permanent 
> > maimings from that invention he invents C and Unix.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
