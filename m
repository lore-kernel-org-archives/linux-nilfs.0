From: "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: deadlock-like issue with order=strict mounts
Date: Mon, 30 Jun 2014 20:48:13 -0400
Message-ID: <53B2054D.7060001@gmail.com>
References: <53B1946D.5020507@gmail.com> <20140701.025501.1772353048154202819.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=awGmHPznrfg/k9BK5xgFro8/iMiTBpzM1odbjVMHx/4=;
        b=cZjRPaXZyJ6COT8ICIlhCXGyo1hxc2Op4VU3Q6413RUpK0cuSuPLt4cA3H6z2u1vCz
         2kub+tY9PttlVyS6mt0Ie0RiSR3ySC7zZQw9e+D7qFuYlkaYtoNLGh4EMEhmIHbnSc51
         6KP3ZMxjD2L1QBkOao2+67yQn98nuI1pBrhF7x/9n3s0pcA5n9665gvyDohkl1D5fIMv
         Y/EDzxveipCJH8elq/WQz+5eZb5LXi1OUEX+xjwoWUNOp2YbTjaw22gQrIDMtsbVUe9Z
         iAzoLiSTq+pit48xp6gjtr1KFlga9b/8fbUnsb8vH4BN9Dol8V7RXVCPiA4hJLLvsbC4
         Vu8A==
In-Reply-To: <20140701.025501.1772353048154202819.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>

On 06/30/2014 01:55 PM, Ryusuke Konishi wrote:
> On Mon, 30 Jun 2014 12:46:37 -0400, "Michael L. Semon" wrote:
>> Hi!  With debugging being discussed here, I wanted to pass on an issue 
>> that has no error message associated with it.  This will be one of those 
>> error reports that Vyacheslav will find not too informative.  He's 
>> been trying to help with those moments where NILFS2 will stop responding 
>> for no visible reason, but whatever issue has 100% reproducibility on 
>> my PC has no reproducibility on his PC.  This is a new test; maybe this 
>> test will work.
> <snip>
>> After forcing a crash and collecting the core dump, I see this using 
>> the crash 7.0.4 program:
>>
>> crash> bt 274
>> PID: 274    TASK: dd9caac0  CPU: 0   COMMAND: "segctord"
>>  #0 [c0063d48] __schedule at c1641357
>>  #1 [c0063dc8] schedule at c1641a7e
>>  #2 [c0063dd0] inode_wait at c11467c8
>>  #3 [c0063dd8] __wait_on_bit at c1642133
>>  #4 [c0063df0] __inode_wait_for_writeback at c1156d98
>>  #5 [c0063e24] inode_wait_for_writeback at c1159fff
>>  #6 [c0063e34] evict at c11475de
>>  #7 [c0063e48] iput at c11482ef
>>  #8 [c0063e60] nilfs_dispose_list at c12f104a
>>  #9 [c0063ecc] nilfs_transaction_unlock at c12f14e9
>> #10 [c0063edc] nilfs_segctor_thread at c12f3fa1
>> #11 [c0063f28] kthread at c105fb56
>> #12 [c0063fb0] ret_from_kernel_thread at c164729e
>>
>> crash> bt 301
>> PID: 301    TASK: dd9cc020  CPU: 0   COMMAND: "sync"
>>  #0 [de9e1dac] __schedule at c1641357
>>  #1 [de9e1e2c] schedule at c1641a7e
>>  #2 [de9e1e34] schedule_timeout at c1640a80
>>  #3 [de9e1ea8] wait_for_completion at c1642436
>>  #4 [de9e1ed4] sync_inodes_sb at c115ae12
>>  #5 [de9e1f7c] sync_inodes_one_sb at c115e620
>>  #6 [de9e1f84] iterate_supers at c112d1e8
>>  #7 [de9e1fa0] sys_sync at c115e85c
>>  #8 [de9e1fb0] ia32_sysenter_target at c164736b
>>     EAX: 00000024  EBX: bf8b1954  ECX: 00000000  EDX: b775517c 
>>     DS:  007b      ESI: 00000001  ES:  007b      EDI: 00000000
>>     SS:  007b      ESP: bf8b187c  EBP: bf8b18b8  GS:  0000
>>     CS:  0073      EIP: b776da8c  ERR: 00000024  EFLAGS: 00000246 
> 
> Uum, this seems a deadlock issue over I_SYNC flag on inode->i_state.
> If so, the issue looks reproducible also for default mount by calling
> sync command and removing files repeatedly.
> 
> Can you try it ?
> 
> Regards,
> Ryusuke Konishi

It was fine on the default mount.  The script above was used until a 
4GB partition was 65% full.  Then, I added more threads and populated 
it again until the filesystem ran out of space.  No problems.

In case you or Vyacheslav need the kernel config, it is here:

https://drive.google.com/file/d/0B41268QKoNjtSUE0SkZsb0E5ckE

I had a similar issue with xfstests; one of the stack traces 
may have ended with "no locks were held by segctord/8879."  However, 
those files did not make it to my USB key to bring here.  They will 
be included next time, so that I can verify that message.  [My memory 
is not very good at times.]

Thanks again!

Michael

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
