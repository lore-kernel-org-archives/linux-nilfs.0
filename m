From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: New experience with the odd problem starting nilfs_cleanerd due to an eMMC misbehaviour
Date: Sun, 30 Jun 2013 15:49:46 +0400
Message-ID: <0F7AA038-9A6B-47AB-AE0F-EF623B0DBA31@dubeyko.com>
References: <20130110131659.GA29689@home.lan> <1357824862.2050.48.camel@slavad-ubuntu> <20130630074404.GI22224@home.lan> <20130630075626.GJ22224@home.lan>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=rFkRIiZqs7YLECUCr4EE+flTL1mrRpf98mEqhNB54MQ=;
	b=DEzTXG+bHmf5QBmfMLzlH91OCGq79aP+Je0NADP5d/wf/nWWL7lUwOcyOOtd9lhFbEGsy5f46ZEEVATtkeEnkjtPX/s9+FXebSOFdx0g4opeXQ0Jwa8ut/VBPQMxTZjb;
In-Reply-To: <20130630075626.GJ22224-0MSThuzptbI@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Paul Fertser <fercerpav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Paul,

On Jun 30, 2013, at 11:56 AM, Paul Fertser wrote:

> On Sun, Jun 30, 2013 at 11:44:04AM +0400, Paul Fertser wrote:
>> Attaching dumpseg output for segment 2713, strace for nilfs_cleanerd,
>> etc, HTH.
> 
> But now zeroing out the eMMC sectors that lead to errors didn't help,
> I get
> 
> [   81.903509] nilfs_cpfile_delete_checkpoints: invalid range of checkpoint numbers: [0, 436896)
> [   81.912342] NILFS: GC failed during preparation: cannot delete checkpoints: err=-22
> 
> Jun 30 11:51:43 ac100-debian nilfs_cleanerd[1553]: start
> Jun 30 11:51:43 ac100-debian nilfs_cleanerd[1553]: pause (clean check)
> Jun 30 11:51:43 ac100-debian nilfs_cleanerd[1553]: resume (clean check)
> Jun 30 11:51:43 ac100-debian nilfs_cleanerd[1553]: ncleansegs = 464
> Jun 30 11:51:43 ac100-debian nilfs_cleanerd[1553]: 4 segments selected to be cleaned
> Jun 30 11:51:43 ac100-debian nilfs_cleanerd[1553]: cannot clean segments: Invalid argument
> Jun 30 11:51:43 ac100-debian nilfs_cleanerd[1553]: shutdown
> 

Such error likewise (NILFS: GC failed during preparation: cannot read source blocks: err=-17)
was reported by another user too. Currently, I am waiting debugging output from him. I suppose
that this issue was reported by many users with slightly different symptoms. But, of course, it can
be a different issues.

What a pity that you tried to zeroing blocks. So, we can't investigate the issue in initial state.
But as I can see the issue doesn't vanish. It means for me that we can investigate the issue anyway.

As I said earlier, I think that it is the issue that was reported by many users. So, it will be a great
if you agree to spend some time on the issue investigation.

> I've no backups for this volume which is a rootfs on my netbook, not
> that it has something very important but I'd like to keep it
> functional... Any ideas how to proceed?
> 

I need additional details about the issue:
1. Please, share with me output of dumpseg for all segments.

2. You shared content of primary superblock. But I need to know the content of secondary superblock too.
Usually, the secondary superblock is placed in last block of the volume. So, you can share with me raw
dump of last block. But I think that it can be more easy for you and more informative for me to share
debug output of fsck utility (http://dubeyko.com/development/FileSystems/NILFS/nilfs-utils-fsck-v.0.04-under-development.tar.gz):

fsck.nilfs2 -v debug <device> 2> output_file.txt

This output will be a big in size. So, it makes sense to share it only with me.

3. Please, share with me debug output for the case of the issue reproducing. I send you in private
e-mail archive this patch set. You need to patch your kernel source tree by this patch set. Then,
it needs to configure kernel with enabling of such configuration options:
CONFIG_NILFS2_DEBUG_SHOW_ERRORS, CONFIG_NILFS2_DEBUG_DUMP_STACK,
CONFIG_NILFS2_DEBUG_BASE_OPERATIONS, CONFIG_NILFS2_DEBUG_MDT_FILES,
CONFIG_NILFS2_DEBUG_GC_SUBSYSTEM, CONFIG_NILFS2_DEBUG_RECOVERY_SUBSYSTEM,
CONFIG_NILFS2_DEBUG_BLOCK_MAPPING, CONFIG_NILFS2_DEBUG_HEXDUMP.
Rebuild your kernel after configuration. Reproduce the issue after kernel restart. If all steps will be
ended successfully then you will have detailed debug output in the system log. You need only share
it with me.

So, when I will have all additional details then I can investigate the issue more deeply. And I hope
that I will have enough for fast fix of the issue.

Thanks,
Vyacheslav Dubeyko.

> -- 
> Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
> mailto:fercerpav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
