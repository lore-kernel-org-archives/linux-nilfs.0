From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Ability to discard all changes after a point in time?
Date: Fri, 27 May 2011 23:03:41 +0900 (JST)
Message-ID: <20110527.230341.1911644859425823915.konishi.ryusuke@gmail.com>
References: <201105270944.52201.m.przybylski@bkfmyjnie.pl>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=domainkey-signature:sender:date:message-id:to:cc:subject:from
         :in-reply-to:references:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        bh=om4fW549fUMzAKyz9vRaJpDXTTqn0kG8JGXHzUz3q1E=;
        b=wWZ75QyvBIxOrrMrtGbUFeqRBT+0sk5sbpH86KH2kr01BrelnyKCe50kEBcE4jOkEg
         thQyPpKPnlcuqi7nxC6oQFBx4/RQVc1kKZRTFImc68dclf+4E4GWAg5fUjDkguXowItb
         MEImE6ii7vsbvXbKKVSA8P+BqRDOFODpgm07s=
In-Reply-To: <201105270944.52201.m.przybylski-HTS31/ZL/NClPcVs/6D9LQ@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="iso-2022-jp"
To: m.przybylski-HTS31/ZL/NClPcVs/6D9LQ@public.gmane.org
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,
On Fri, 27 May 2011 09:44:51 +0200, Mateusz Jan Przybylski wrote:
> Hi Ryusuke,
> 
> On Friday 27 of May 2011 09:34:34 you wrote:
>> The feature is indeed one of todo items, and I just have been
>> considering the topic for upcoming LinuxCon Japan.
>> 
>> At present, I made a patchset which can revert only one fully deleted
>> regular file without duplicating data blocks. (This work derives your
>> post titled "It is not possible to restore file from a mounted
>> snapshot using a hardlink" and the successive reflink topic.)
>> 
>> 
>> The challenge in the rollback (or revert) feature is to handle
>> lifetime of each disk block, which is maintained for garbage
>> collection.  (a disk address table, which we call DAT file, preserves
>> this metadata).
>> 
>> The mount-time whole checkpoint reversion, that is to say rollback,
>> seems rather difficult than this.  In my estimation, it would take too
>> long time to rewrite whole DAT file.
> 
> thanks for prompt reply.
> 
> I'm surprised this is that complex. My limited understanding of NILFS2 was 
> that the latest complete checkpoint is considered `the current one' during 
> mount. The big idea was to irreversibly destroy (by actually overwritting 
> relevant metadata) the checkpoints if admin indicated that wish with the 
> supposed new `rollbackto=<checkpoint_number>' parameter. Just before the mount 
> operation; perhaps even going through the normal rountine for recovery after 
> unclean mount.
> 
> After that, the latest remaining checkpoint (the one indicated in option) 
> would be the current state of the FS. The metadata from that checkpoint would
> be used, and newer metadata from newer checkpoints would simply be 
> inaccessible to the driver. No new checkpoint would be created in that case, 
> unlike the action of `rmcp' command.
>
> How far am I here from the actual workings of the filesystem?

Unfortunately, some of the metadata such as the DAT file is global to
the filesystem and does not belong to any checkpoints.  Your thought
is roughly correct, but we also have to care the DAT file as well as
the checkpoint information.  Otherwise, the next garbage collection
will collapse the filesystem.

Regards,
Ryusuke Konishi
 
> meta: oops, sent reply directly to Ryusuke again. Sorry~
> 
> 
> Regards
> --
> dexen deVries
> 
> [[[↓][→]]]
> 
> For example, if the first thing in the file is:
>    <?kzy irefvba="1.0" rapbqvat="ebg13"?>
> an XML parser will recognize that the document is stored in the traditional 
> ROT13 encoding.
> 
> (( Joe English, http://www.flightlab.com/~joe/sgml/faq-not.txt ))
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
