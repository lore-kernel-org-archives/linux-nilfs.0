From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2] fs/nilfs2: Integer overflow in
 nilfs_ioctl_wrap_copy()
Date: Sat, 04 Jan 2014 18:06:46 +0900 (JST)
Message-ID: <20140104.180646.52171591.konishi.ryusuke@lab.ntt.co.jp>
References: <1388729454-30256-1-git-send-email-fanwlexca@gmail.com>
	<20140103161015.b354edd36176e4016840135b@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140103161015.b354edd36176e4016840135b-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Andrew,
On Fri, 3 Jan 2014 16:10:15 -0800, Andrew Morton wrote:
> On Fri,  3 Jan 2014 14:10:54 +0800 Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
>> v1->v2
>> *Check on every iteration is removed because the check before cycle is enough.
>> 
>> Check before entering into cycle.
>> 
>> The local variable 'pos' comes from userspace. If a large number was
>> passed, there would be an integer overflow in the following line:
>>         pos += n;
>> 
>> Signed-off-by: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  fs/nilfs2/ioctl.c | 3 +++
>>  1 file changed, 3 insertions(+)
>> 
>> diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
>> index b44bdb2..231c945 100644
>> --- a/fs/nilfs2/ioctl.c
>> +++ b/fs/nilfs2/ioctl.c
>> @@ -57,6 +57,9 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
>>  	if (argv->v_size > PAGE_SIZE)
>>  		return -EINVAL;
>>  
>> +	if (argv->v_index > (~(__u64)0 - argv->v_nmembs))
>> +		return -EINVAL;
>> +
>>  	buf = (void *)__get_free_pages(GFP_NOFS, 0);
>>  	if (unlikely(!buf))
>>  		return -ENOMEM;
> 
> Geeze, that function is really hard to understand.  The poor
> documentation for nilfs_argv.v_index is hurting here.
> 
> Why doesn't this patch do
> 
> 	if (argv->v_index >= argv->v_nmembs)
> 		return -EINVAL;
> 
> ?
> 
> That's what one would *expect* to see, so something weird must be going
> on?

Sorry for the poor documentation of nilfs_argv struct and
nilfs_ioctl_wrap_copy function.

argv->v_index is not an index of argv->v_base[] array but gives a
start position of the data items that userland programs want to get
information about.

For instance, a segment number is given in case to get segment
information, a checkpoint number is given for checkpoint information,
or virtual block address is given for disk block information.

argv->v_nmembs gives the number of the items that userland programs
want to get information about.

The inserted check ensures that (argv->v_index + argv->v_nmembs)
doesn't exceed the maximum value of __u64 type integer, and prevents
overflow of the position variable 'pos'.


I modified the commit log and also added a few comment lines to
clarify the address of the patch.  The modified patch is attached
below.

I think this patch is a minor fix and is not urgent since the overflow
looks not to cause security issue nor kernel panic.

Thanks,
Ryusuke Konishi

----
From: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

nilfs2: prevent integer overflow in nilfs_ioctl_wrap_copy()

The local variable 'pos' in nilfs_ioctl_wrap_copy function can
overflow if a large number was passed to argv->v_index from userspace
and the sum of argv->v_index and argv->v_nmembs exceeds the maximum
value of __u64 type integer (= ~(__u64)0 = 18446744073709551615).

Here, argv->v_index is a 64-bit width argument to specify the start
position of target data items (such as segment number, checkpoint
number, or virtual block address of nilfs), and argv->v_nmembs gives
the total number of the items that userland programs (such as lssu,
lscp, or cleanerd) want to get information about, which also gives the
maximum element count of argv->v_base[] array.

nilfs_ioctl_wrap_copy() calls dofunc() repeatedly and increments the
position variable 'pos' at the end of each iteration if dofunc()
itself didn't update 'pos':

      if (pos == ppos)
              pos += n;

This patch prevents the overflow here by rejecting pairs of a start
position (argv->v_index) and a total count (argv->v_nmembs) which
leads to the overflow.

v1->v2:
* Check on every iteration is removed because the check before
  cycle is enough.

Signed-off-by: Wenliang Fan <fanwlexca-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
---
 fs/nilfs2/ioctl.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index b44bdb2..d22281d 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -57,6 +57,14 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 	if (argv->v_size > PAGE_SIZE)
 		return -EINVAL;
 
+	/*
+	 * Reject pairs of a start item position (argv->v_index) and a
+	 * total count (argv->v_nmembs) which leads position 'pos' to
+	 * overflow by the increment at the end of the loop.
+	 */
+	if (argv->v_index > ~(__u64)0 - argv->v_nmembs)
+		return -EINVAL;
+
 	buf = (void *)__get_free_pages(GFP_NOFS, 0);
 	if (unlikely(!buf))
 		return -ENOMEM;
-- 
1.7.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
