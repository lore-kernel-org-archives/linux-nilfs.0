From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Subject: Re: [PATCH 0/2] nilfs2: improve inode allocation algorithm
Date: Mon, 13 Oct 2014 18:18:34 +0200
Message-ID: <543BFB5A.9090301@gmx.net>
References: <1413110303-14246-1-git-send-email-andreas.rohner@gmx.net> <20141013.235259.2281467595116868273.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141013.235259.2281467595116868273.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014-10-13 16:52, Ryusuke Konishi wrote:
> Hi,
> On Sun, 12 Oct 2014 12:38:21 +0200, Andreas Rohner wrote:
>> Hi,
>>
>> The algorithm simply makes sure, that after a directory inode there are
>> a certain number of free slots available and the search for file inodes
>> is started at their parent directory.
>>
>> I havn't had the time yet to do a full scale performance test of it, but 
>> my simple preliminary tests have shown, that the allocation of inodes 
>> takes a little bit longer and the lookup is a little bit faster. My 
>> simple test just creates 1500 directories and after that creates 10 
>> files in each directory.
>>
>> So more testing is definetly necessary, but I wanted to get some 
>> feedback about the design first. Is my code a step in the right 
>> direction?
>>
>> Best regards,
>> Andreas Rohner
>>
>> Andreas Rohner (2):
>>   nilfs2: support the allocation of whole blocks of meta data entries
>>   nilfs2: improve inode allocation algorithm
>>
>>  fs/nilfs2/alloc.c   | 161 ++++++++++++++++++++++++++++++++++++++++++++++++----
>>  fs/nilfs2/alloc.h   |  18 +++++-
>>  fs/nilfs2/ifile.c   |  63 ++++++++++++++++++--
>>  fs/nilfs2/ifile.h   |   6 +-
>>  fs/nilfs2/inode.c   |   6 +-
>>  fs/nilfs2/segment.c |   5 +-
>>  6 files changed, 235 insertions(+), 24 deletions(-)
> 
> I don't know whether this patchset is going in the right direction.
> .. we should first measure how the original naive allocator is bad in
> comparison with an elaborately designed allocator like this.  But, I
> will add some comments anyway:

I think the alignment creates a lot of overhead, because every directory
uses up a whole block in the ifile. I could also create a simpler patch
that only stores the last allocated inode number in struct
nilfs_ifile_info and starts the search from there for the next
allocation. Then I can test the three versions against each other in a
large scale test.

>  1) You must not use sizeof(struct nilfs_inode) to get inode size.
>     The size of on-disk inodes is variable and you have to use
>     NILFS_MDT(ifile)->mi_entry_size to ensure compatibility.
>     To get ipb (= number of inodes per block), you should use
>     NILFS_MDT(ifile)->mi_entries_per_block.
>     Please remove nilfs_ifile_inodes_per_block().  It's redundant.

Agreed.

>  2) __nilfs_palloc_prepare_alloc_entry()
>     The argument block_size is so confusing. Usually we use it
>     for the size of disk block.
>     Please use a proper word "alignment_size" or so.

Yes that's true "alignment_size" sounds better.

>  3) nilfs_palloc_find_available_slot_align32()
>     This function seems to be violating endian compatibility.
>     The order of two 32-bit words in a 64-bit word in little endian
>     architectures differs from that of big endian architectures.
> 
>     Having three different implementations looks too overkill to me at
>     this time.  It should be removed unless it will make a significant
>     difference.

32 is the most common case (4096 block size and 128 inode size), so I
thought it makes sense to optimize for it. But it is not necessary and
it shouldn't make a big difference.

>  4) nilfs_cpu_to_leul()
>     Adding this macro is not preferable.  It depends on endian.
>     Did you look for a generic macro which does the same thing ?

There are only macros for specific bit lengths, as far as I know. But
unsigned long varies for 32bit and 64bit systems. You could also
implement it like this:

#if BITS_PER_LONG == 64
#define nilfs_cpu_to_leul	cpu_to_le64
#elif BITS_PER_LONG == 32
#define nilfs_cpu_to_leul	cpu_to_le32
#else
#error BITS_PER_LONG not defined
#endif

Best regards,
Andreas Rohner
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
