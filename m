From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: NILFS: corrupt root inode after Turbo Mode?
Date: Thu, 25 Oct 2012 16:13:46 +0400
Message-ID: <1351167226.2573.28.camel@slavad-ubuntu>
References: <20121014200836.GK27763@wloczykij>
	 <1350281888.2488.9.camel@slavad-ubuntu> <20121018201528.GS27763@wloczykij>
	 <1350628991.2028.25.camel@slavad-ubuntu> <20121019101421.GT27763@wloczykij>
	 <1350973913.2041.25.camel@slavad-ubuntu> <20121023084100.GW27763@wloczykij>
	 <1350984395.2041.32.camel@slavad-ubuntu> <20121023115458.GA27763@wloczykij>
	 <1350999330.2041.48.camel@slavad-ubuntu> <20121024073641.GB27763@wloczykij>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=KhazwrPlhgAHDuQ23lWL6pkMBoLd47LHDtendW/MorA=;
	b=SnCq/fiWh58a8q3jfDUnw+aNARBcg5xzQMouXUByEExolxYpVHYqhUQHSruPnglf4KLHp9zvsczrWqE90b3GwqhhOStdI+4euMDRrHfEqwSuEx+S2n5Of6wMjCadcieb;
In-Reply-To: <20121024073641.GB27763@wloczykij>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Piotr Szymaniak <szarpaj-TbOm9Ca2r9GrDJvtcaxF/A@public.gmane.org>
Cc: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 2012-10-24 at 09:36 +0200, Piotr Szymaniak wrote:
> On Tue, Oct 23, 2012 at 05:35:30PM +0400, Vyacheslav Dubeyko wrote:
> > I think that the issue is the concrete SD-card's issue. So, if you
> > simply dump out the image on another SD-card then, I hope, all will work
> > fine.
> 
> But what could be the issue with SD-card?
> 

There are several possible reasons of the issue:
1. Volume corruption.
2. File system driver issue.
3. Hardware issue.

The volume corruption is steady reproducible in the case of file system
driver issue on any computer system with achieving necessary
environment. The reported issue is not so because you can't mount volume
on SD-card but you can mount it as image on loop device. And you have
different messages in these two cases.

The reported issue can be a NILFS2 file system driver issue with some
probability. But, as I understand, first of all, you mounted this NILFS2
volume many times in normal mode on this SD-card. Secondly, we haven't
reproduction path of the reported issue for the case of Turbo mode. So,
it is impossible to talk something about possible file system driver
issue without understanding of technical environment and file system
operations that were a reason.

The hardware issue can have more probability, from my point of view. The
MMC protocol describes negotiation procedure between SD-card and
SD-controller. It defines voltage, frequency and operation mode between
controller and card during initialization phase. So, I think that it
takes place some in-proper negotiation for the case of Turbo mode or,
maybe, issue of concrete hardware realization of SD-card controller or
SD-controller on board. Moreover, it is possible also situation of SD
card's NAND flash wearing. As a result, writing or reading operations
can be failed partially or completely sometimes.

With the best regards,
Vyacheslav Dubeyko.


> Anyway, I did a second image, mounted it as before and it works. dmesg
> shows:
> [ 2740.544690] NILFS warning: broken superblock. using spare superblock (blocksize = 1024).
> [ 2740.544754] NILFS warning: broken superblock. using spare superblock (blocksize = 4096).
> [ 2740.544760] NILFS warning: mounting unchecked fs
> [ 2740.861477] NILFS: recovery complete.
> [ 2740.911019] segctord starting. Construction interval = 300 seconds, CP frequency < 30 seconds
> 
> I will try to put the image after mount/umount back to the SD-card and
> check if it works on Raspberry Pi.
> 
> 
> Piotr Szymaniak.


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
