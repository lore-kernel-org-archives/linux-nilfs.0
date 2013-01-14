From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix very long mount time issue
Date: Tue, 15 Jan 2013 08:38:09 +0900
Message-ID: <201301142338.AA04488@capsicum.lab.ntt.co.jp>
References: <20130114150041.d57e5e03.akpm@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130114150041.d57e5e03.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org, splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

>On Sun, 13 Jan 2013 16:07:23 +0900 (JST)
>Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
>
>> On Sat, 12 Jan 2013 19:34:48 +0400, Vyacheslav Dubeyko wrote:
>> > From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
>> > Subject: [PATCH] nilfs2: fix very long mount time issue
>> > 
>> > DESCRIPTION:
>> > It exists situation when GC can work in background alone without any other filesystem activity during significant 
time. The nilfs_clean_segments() method calls nilfs_segctor_construct() that updates superblocks in the case of 
NILFS_SC_SUPER_ROOT and THE_NILFS_DISCONTINUED flags are set. But when GC is working alone the nilfs_clean_segments() is 
called with unset THE_NILFS_DISCONTINUED flag. As a result, the update of superblocks doesn't occurred all this time and 
in the case of SPOR superblocks keep very old values of last super root placement.
>> > 
>> > SYMPTOMS:
>> > Trying to mount a NILFS2 volume after SPOR in such environment ends with very long mounting time (it can achieve 
about several hours in some cases).
>> > 
>> > REPRODUCING PATH:
>> > 1. It needs to use external USB HDD, disable automount and doesn't make any additional filesystem activity on the 
NILFS2 volume.
>> > 2. Generate temporary file with size about 100 - 500 GB (for example, dd if=/dev/zero of=<file_name> bs=1073741824 
count=200). The size of file defines duration of GC working.
>> > 3. Then it needs to delete file.
>> > 4. Start GC manually by means of command "nilfs-clean -p 0". When you start GC by means of such way then, at the end, 
superblocks is updated by once. So, for simulation of SPOR, it needs to wait sometime (15 - 40 minutes) and simply switch 
off USB HDD manually.
>> > 5. Switch on USB HDD again and try to mount NILFS2 volume. As a result, NILFS2 volume will mount during very long 
time.
>> > 
>> > REPRODUCIBILITY: 100%
>> > 
>> > FIX:
>> > This patch adds checking that superblocks need to update and set THE_NILFS_DISCONTINUED flag before 
nilfs_clean_segments() call.
>> > 
>> > Reported-by: Sergey Alexandrov <splavgm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> > Signed-off-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
>> > Tested-by: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
>> 
>> Acked-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
>> 
>> Thanks, Vyacheslav.  I confirmed the issue and could reproduce it.
>> Your patch fixed it.
>> 
>> Andrew, please apply.
>
>I added a Cc:stable so the fix will be backported into earlier kernels.
>40 minutes mount time is pretty bad!

Yup, I agree.

Thanks.

Ryusuke Konishi

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
