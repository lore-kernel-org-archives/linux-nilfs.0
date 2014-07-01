From: "Michael L. Semon" <mlsemon35-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: deadlock-like issue with order=strict mounts
Date: Tue, 01 Jul 2014 17:59:31 -0400
Message-ID: <53B32F43.8010400@gmail.com>
References: <53B1946D.5020507@gmail.com> <20140701.025501.1772353048154202819.konishi.ryusuke@lab.ntt.co.jp> <53B2054D.7060001@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=sACmm8I+zMLuV9O24kFpcWT4a84jGeChwXiJNJOGzCc=;
        b=D6dwW4wcQsMZQxU5JCk14mk7+eX5HayHqi89Cqsf2duRy3aHUlHa8yR1FjNMK76Uik
         bhZYy1PXRpVLjxDVI3rOQOA0azXwL9+SELFBotZnrnAzpQOV+zJpyZWPpWcc9kA6xW01
         ltLNEUbdiNBi+5MZQLIatYEC1xn4GxZPL83JMpykr7YFuMVw86a9nmwhAure1lLgtert
         2s3nAhG3xwNIB9ElHb9j7Q6Pf66lkouoFykG3jSk5Qn9frFCoLZmpiDHYiqlTPPLGZHp
         jJmmbdET/RGRwIusf0XVTmuwfjAaigFXohN04hsSELIMSbbqV5O3H7JaLkQ5Yn+Adz3P
         IsWA==
In-Reply-To: <53B2054D.7060001-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>

On 06/30/2014 08:48 PM, Michael L. Semon wrote:
> On 06/30/2014 01:55 PM, Ryusuke Konishi wrote:
>> On Mon, 30 Jun 2014 12:46:37 -0400, "Michael L. Semon" wrote:
>>> Hi!  With debugging being discussed here, I wanted to pass on an issue 
>>> that has no error message associated with it.  This will be one of those 
>>> error reports that Vyacheslav will find not too informative.  He's 
>>> been trying to help with those moments where NILFS2 will stop responding 
>>> for no visible reason, but whatever issue has 100% reproducibility on 
>>> my PC has no reproducibility on his PC.  This is a new test; maybe this 
>>> test will work.
>> <snip>
>>> After forcing a crash and collecting the core dump, I see this using 
>>> the crash 7.0.4 program:
>>>
>>> crash> bt 274
>>> PID: 274    TASK: dd9caac0  CPU: 0   COMMAND: "segctord"
>>>  #0 [c0063d48] __schedule at c1641357
>>>  #1 [c0063dc8] schedule at c1641a7e
>>>  #2 [c0063dd0] inode_wait at c11467c8
>>>  #3 [c0063dd8] __wait_on_bit at c1642133
>>>  #4 [c0063df0] __inode_wait_for_writeback at c1156d98
>>>  #5 [c0063e24] inode_wait_for_writeback at c1159fff
>>>  #6 [c0063e34] evict at c11475de
>>>  #7 [c0063e48] iput at c11482ef
>>>  #8 [c0063e60] nilfs_dispose_list at c12f104a
>>>  #9 [c0063ecc] nilfs_transaction_unlock at c12f14e9
>>> #10 [c0063edc] nilfs_segctor_thread at c12f3fa1
>>> #11 [c0063f28] kthread at c105fb56
>>> #12 [c0063fb0] ret_from_kernel_thread at c164729e
>>>
>>> crash> bt 301
>>> PID: 301    TASK: dd9cc020  CPU: 0   COMMAND: "sync"
>>>  #0 [de9e1dac] __schedule at c1641357
>>>  #1 [de9e1e2c] schedule at c1641a7e
>>>  #2 [de9e1e34] schedule_timeout at c1640a80
>>>  #3 [de9e1ea8] wait_for_completion at c1642436
>>>  #4 [de9e1ed4] sync_inodes_sb at c115ae12
>>>  #5 [de9e1f7c] sync_inodes_one_sb at c115e620
>>>  #6 [de9e1f84] iterate_supers at c112d1e8
>>>  #7 [de9e1fa0] sys_sync at c115e85c
>>>  #8 [de9e1fb0] ia32_sysenter_target at c164736b
>>>     EAX: 00000024  EBX: bf8b1954  ECX: 00000000  EDX: b775517c 
>>>     DS:  007b      ESI: 00000001  ES:  007b      EDI: 00000000
>>>     SS:  007b      ESP: bf8b187c  EBP: bf8b18b8  GS:  0000
>>>     CS:  0073      EIP: b776da8c  ERR: 00000024  EFLAGS: 00000246 
>>
>> Uum, this seems a deadlock issue over I_SYNC flag on inode->i_state.
>> If so, the issue looks reproducible also for default mount by calling
>> sync command and removing files repeatedly.
>>
>> Can you try it ?
>>
>> Regards,
>> Ryusuke Konishi
> 
> It was fine on the default mount.  The script above was used until a 
> 4GB partition was 65% full.  Then, I added more threads and populated 
> it again until the filesystem ran out of space.  No problems.
> 
> In case you or Vyacheslav need the kernel config, it is here:
> 
> https://drive.google.com/file/d/0B41268QKoNjtSUE0SkZsb0E5ckE
> 
> I had a similar issue with xfstests; one of the stack traces 
> may have ended with "no locks were held by segctord/8879."  However, 
> those files did not make it to my USB key to bring here.  They will 
> be included next time, so that I can verify that message.  [My memory 
> is not very good at times.]

OK, here's the stack traces that were missing last time.  This involves 
segctord and umount.nilfs2:

# Command line: env MOUNT_OPTIONS='-o pp=0,order=strict' ./check -g auto
# Test generic/001 passes, but segctord and umount.nilfs2 become 
# unresponsive and trigger the kernel hung task detector.

[ 3824.349820] segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
[ 3828.544963] segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
[ 3829.805282] segctord starting. Construction interval = 5 seconds, CP frequency < 30 seconds
[ 5040.128148] INFO: task segctord:8987 blocked for more than 720 seconds.
[ 5040.128227]       Not tainted 3.16.0-rc2+ #12
[ 5040.128249] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5040.128272] segctord        D c10870e4  6124  8987      2 0x00000000
[ 5040.128354]  de9ffdc4 00000086 00000000 c10870e4 00000000 de9ffd94 c18d9000 0ad32d1d
[ 5040.128487]  00000388 c1802780 ddb85580 00000000 de9ffda8 00000046 00000082 00000002
[ 5040.128618]  dfebb000 dfebaff0 00000001 00000046 00000296 dfebaff0 de9ffda8 c108909b
[ 5040.128749] Call Trace:
[ 5040.128812]  [<c10870e4>] ? lock_release_holdtime.part.25+0xb4/0x100
[ 5040.128859]  [<c108909b>] ? trace_hardirqs_on+0xb/0x10
[ 5040.128913]  [<c1641a83>] schedule+0x23/0x60
[ 5040.128968]  [<c11467cd>] inode_wait+0xd/0x20
[ 5040.129081]  [<c1642135>] __wait_on_bit+0x55/0x80
[ 5040.129125]  [<c11467c0>] ? inode_lru_list_del+0x30/0x30
[ 5040.129170]  [<c1156d9d>] __inode_wait_for_writeback+0x8d/0xb0
[ 5040.129227]  [<c107f3f0>] ? autoremove_wake_function+0x50/0x50
[ 5040.129274]  [<c115a004>] inode_wait_for_writeback+0x24/0x40
[ 5040.129316]  [<c11475e3>] evict+0x83/0x160
[ 5040.129358]  [<c11482f4>] iput+0xe4/0x190
[ 5040.129421]  [<c12f105f>] nilfs_dispose_list+0x11f/0x180
[ 5040.129463]  [<c12f14de>] ? nilfs_transaction_unlock.isra.27+0x3e/0x80
[ 5040.129503]  [<c12f14fe>] nilfs_transaction_unlock.isra.27+0x5e/0x80
[ 5040.129544]  [<c12f3fb6>] nilfs_segctor_thread+0xf6/0x300
[ 5040.129584]  [<c12f3ec0>] ? nilfs_segctor_construct+0x300/0x300
[ 5040.129629]  [<c105fb58>] kthread+0xa8/0xc0
[ 5040.129671]  [<c108909b>] ? trace_hardirqs_on+0xb/0x10
[ 5040.129712]  [<c16472a1>] ret_from_kernel_thread+0x21/0x30
[ 5040.129752]  [<c105fab0>] ? insert_kthread_work+0x80/0x80
[ 5040.129779] no locks held by segctord/8987.

crash> bt 8987
PID: 8987   TASK: ddb85580  CPU: 0   COMMAND: "segctord"
 #0 [de9ffd48] __schedule at c1641357
 #1 [de9ffdc8] schedule at c1641a7e
 #2 [de9ffdd0] inode_wait at c11467c8
 #3 [de9ffdd8] __wait_on_bit at c1642133
 #4 [de9ffdf0] __inode_wait_for_writeback at c1156d98
 #5 [de9ffe24] inode_wait_for_writeback at c1159fff
 #6 [de9ffe34] evict at c11475de
 #7 [de9ffe48] iput at c11482ef
 #8 [de9ffe60] nilfs_dispose_list at c12f105a
 #9 [de9ffecc] nilfs_transaction_unlock at c12f14f9
#10 [de9ffedc] nilfs_segctor_thread at c12f3fb1
#11 [de9fff28] kthread at c105fb56
#12 [de9fffb0] ret_from_kernel_thread at c164729e

crash> bt 11520
PID: 11520  TASK: dea15580  CPU: 0   COMMAND: "umount.nilfs2"
 #0 [dd84fd44] __schedule at c1641357
 #1 [dd84fdc4] schedule at c1641a7e
 #2 [dd84fdcc] schedule_timeout at c1640a80
 #3 [dd84fe40] wait_for_completion at c1642436
 #4 [dd84fe6c] sync_inodes_sb at c115ae12
 #5 [dd84ff14] sync_filesystem at c115e7df
 #6 [dd84ff20] generic_shutdown_super at c112cc87
 #7 [dd84ff3c] kill_block_super at c112dd14
 #8 [dd84ff4c] deactivate_locked_super at c112c9d5
 #9 [dd84ff5c] deactivate_super at c112ca62
#10 [dd84ff70] mntput_no_expire at c114d4b8
#11 [dd84ff8c] sys_oldumount at c114f25e
#12 [dd84ffb0] ia32_sysenter_target at c164736b
    EAX: 00000016  EBX: 0990e100  ECX: 00000001  EDX: b7750404 
    DS:  007b      ESI: 0990e008  ES:  007b      EDI: 00000000
    SS:  007b      ESP: bfd3ddbc  EBP: b775084c  GS:  0000
    CS:  0073      EIP: b7765a8c  ERR: 00000016  EFLAGS 00000246 

Again, the same test is OK when using a default mount.

Thanks!

Michael

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
