From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Feature request: A user-space program listing versioning
 history of a specified file
Date: Tue, 16 Feb 2016 01:06:31 +0900 (JST)
Message-ID: <20160216.010631.559388498131190624.konishi.ryusuke@lab.ntt.co.jp>
References: <CAFm8q6dfuY9_vrqp_H_rePBBLeZc6TBt20G7pEhpzr5eYifQZA@mail.gmail.com>
	<20160213.015824.937707282163873059.konishi.ryusuke@lab.ntt.co.jp>
	<CAFm8q6eTX4p_i_w7Nsy3R_5xwS=wQVRTw=vJ4f1j0GRJX0LjuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=ifgJSAyGASzykIcEIjAOW6uyHyh7YNmyNhn+NCj+YYY=;
        b=P2e5hBxZxN8yMJbH38r/njWrXAGIjycKONnl4i9EAduArpmZ9MNVl7t06RWH1Ko0X1
         HQfkPIx0dOU7EQ9Ob2nRqEDTTrPLKwCadDlnZdd+66TKKd01p580/HUchU8k/bgqfY/I
         8vEbnIdgHYUixIQvieLB/8dFozi6PMiE0+3lPhUX8YYv6lpZ/BTA51odqKcExdIyL4PQ
         4cMHU+/m/eV5Tc9886V0etTeCnmZHg849k1+i/FEUdrcPqdiKIGWw412vV56AN39XbKc
         80h/aN9ajyaqZHn72IRTRPQXlj+P1UmAw/zZh9qx5vOj1bEo9LVIGyG4FBue2UlKpWXU
         5CFA==
In-Reply-To: <CAFm8q6eTX4p_i_w7Nsy3R_5xwS=wQVRTw=vJ4f1j0GRJX0LjuQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Eric Lan <tenoreamer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, 14 Feb 2016 01:58:01 +0800, Eric Lan <tenoreamer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I think these requests, when materialized, would be very useful and
> become attractive features for NILFS2 because the natural advantages
> (COW & preserving previous versions of files) of NILFS2 become very
> convenient for the users to access to recover old versions of or
> deleted files.
> 
> Actually, I thought it may be possible to use BASH scripting to list
> versions of files. The script may work by mounting checkpoints one by
> one retrogradely to find the specified files with different mtime
> until the absence of the file in a certain checkpoint. But the
> performance would be low. How to collect these versions for users to
> view easily(without mounting by the user again)? I don't know if it is
> possible to make a "hardlink" inode in the current "checkpoint" that
> points to an old version of file. This way, the duplication load could
> be spared. But I wondered if that would interfere with garbage
> collection.

Adding a new ioctl which stores change-point checkpoint numbers for a
specified file (in a given buffer), looks to have a possibility and is
convenient to applications since this approach doesn't require
applications to mount every checkpoint.

From an implementation point of view, however, the following hurdles
exist:

- Disk format change is needed; the current nilfs doesn't have metadata
  that helps to track past versions of a file.

  We may be able to achieve this by storing "previous checkpoint
  number" in each version of inode, but no on-disk field is available
  unless we expand the inode size from the current one (128 bytes).

  Even though the "previous checkpoint" can be deleted by GC, we can
  track back an existent checkpoint from there by traversing btree of
  the checkpoint metadata file in reverse direction.

- How we can track the file path of moved files ?
  Looks like we need another interface to get file paths
  from a given past inode (file).

Regards,
Ryusuke Konishi

> 
> Just sharing some ideas. Anyway, thank you for taking these requests
> into consideration ^^
> 
> Anticipating,
> Eric Lan
> 
> 2016-02-13 0:58 GMT+08:00 Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>:
>> On Fri, 5 Feb 2016 00:59:17 +0800, Eric Lan <tenoreamer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> Hello,
>>>
>>> Recently, I have installed NILFS2 and feel it quite cool. I wonder if
>>> you are insterested in developing a program that can trace back all
>>> the check points to list the revision history of a specified file.
>>> With certain argument specified, these versions of files can be
>>> collected into a directory for the user to choose a good one from.
>>>
>>> Such program may be easily extended to have the function of
>>> "undelete". That is, to collect a series of versions of or the most
>>> recent version of a specific file that exist only in the past
>>> checkpoints.
>>
>> None of your requests look easy to implement ;)
>>
>> Anyway, I added them to the todo list at
>> http://nilfs.sourceforge.net/en/current_status.html
>>
>> Thanks,
>> Ryusuke Konishi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
