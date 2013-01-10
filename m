From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: New experience with the odd problem starting nilfs_cleanerd due
 to an eMMC misbehaviour
Date: Thu, 10 Jan 2013 17:34:22 +0400
Message-ID: <1357824862.2050.48.camel@slavad-ubuntu>
References: <20130110131659.GA29689@home.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=Mime-Version:Content-Transfer-Encoding:Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID; bh=JzrdVg09rKYHBSAW04VnkaciVVkppdZbeUB1oQRhDBU=;
	b=kagEGilAJufkkwRNBuGhbsk+vqlIMfGzwgkLD0XmdKZgWDG8yhJbzatqubWbc47QylNMhn45DJX11EWyf8OL7SudxShuexin1WRE7zb9Syc4CwrcFVW7xhVpkEcNnK78;
In-Reply-To: <20130110131659.GA29689-0MSThuzptbI@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Paul Fertser <fercerpav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On Thu, 2013-01-10 at 17:16 +0400, Paul Fertser wrote:
> Hi,
> 
> I've reported this issue earlier and back then it "resolved itself"
> after a power-cycle. The hardware in question is the same ac100
> netbook with an internal 32GB eMMC.
> 
> On nilfs_cleanerd start i was consistently getting these messages:
> [   46.122096] mmcblk0: error -110 transferring data, sector 26671630, nr 10, card status 0x200900
> [   48.934623] mmcblk0: error -110 transferring data, sector 26671631, nr 9, card status 0x200900
> (and similar output for two other sectors)
> 
> However, this time was different, several full power cycles didn't
> help and the read was still failing and cleanerd refused to start.
> 

Could you share system log content and strace of nilfs_cleanerd's trying
to start in the case of the issue? It needs for the beginning of the
issue understanding. Please, set in the nilfs_cleanerd.conf debug level.

Could you made raw dump of bad sectors? Could you share dumpseg output
for segments which contains the bad sectors?

So, I need to think how to investigate your issue without availability
of eMMC. :-)

Thanks,
Vyacheslav Dubeyko.

> So i resorted to brute force, trying to write to the sectors in
> question. 512 and 2048 byte writes were failing with the same error
> message, so i tried 4096 and it took about a second but succeeded:
> 
> dd if=/dev/zero of=/dev/mmcblk0 bs=4096 count=1 seek=3333953
> 
> Same has to be done with the other failing sector.
> 
> And only after that i was able to start nilfs_cleanerd and my system
> seems to be running fine again.
> 
> If it happened with e.g. ext4, i would be unable to read a certain
> file and after several attempts would simply delete it and the blocks
> in question would get overwritten eventually without any impact for
> the system usability. However, with nilfs had i not figured out the
> "dd" trick i would have to overwrite the whole filesystem (and in fact
> that's the main and only partition on my netbook). The described mmc
> card behaviour (i.e. remapping bad blocks only on write attempts)
> seems to be kind of reasonable and i would expect the same problem to
> happen with someone else one day.
> 
> HTH


--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
