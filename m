From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: Re: [PATCH 3/4] fsfreeze: manage kill signal when sb_start_pagefault
 is called
Date: Sat, 06 Apr 2013 17:00:07 +0200
Message-ID: <51603877.7070904@gmail.com>
References: <515FF380.5020406@gmail.com> <20130406132028.GD28744@parisc-linux.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:message-id:date:from:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        bh=YdfbJG5KsrtmjO1Xg1jZHgSFYS7k9wbVqmG9DhcUvZ8=;
        b=CWQYN6gwVFfFMakg3juIY0PsSC0r3B0EZWM6SbACeVUeBePW6SFWm0AEcUXkbHQGo4
         Vb1dL72WEfdP7sDBgSPqVG7CQGLQ7RYz+q30QKoHvuKNVuqJvVW9gmHZSL3JqrAzG873
         tHj9xbEZw3nbCmLkdNWUa2+MeT9AkOFUa3JXIp7WLmMVQu22KXr9dyel3HbVz1y6tVTD
         8Wn2l9+vXjfSj8jxmt9CG0xJPExQndW5c7gBKNuqChSiTeSsqu9lwcvQat36g2xb8u/9
         BgCra7TmSbEQG+TbsAobXgV6iG8H7RJ9e66QChlAabwf6qR3KLkf1xp3nkZ6ooOfCJ8B
         gXiA==
In-Reply-To: <20130406132028.GD28744@parisc-linux.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk.kim@samsung.com>, Steven Whitehouse <swhiteho@redhat.com>, KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>, Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>, Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, Jan Kara <jack@suse.cz>

Il 06/04/2013 15:20, Matthew Wilcox ha scritto:
> On Sat, Apr 06, 2013 at 12:05:52PM +0200, Marco Stornelli wrote:
>> In every place where sb_start_pagefault was called now we must manage
>> the error code and return VM_FAULT_RETRY.
>
> Erm ... in patch 1/4:
>
>   static inline void sb_start_pagefault(struct super_block *sb)
>   {
> -       __sb_start_write(sb, SB_FREEZE_PAGEFAULT, true);
> +       __sb_start_write_wait(sb, SB_FREEZE_PAGEFAULT, false);
>   }
>
>>
>> -	sb_start_pagefault(inode->i_sb);
>> +	ret = sb_start_pagefault(inode->i_sb);
>> +	if (ret)
>> +		return VM_FAULT_RETRY;
>>   	ret  = btrfs_delalloc_reserve_space(inode, PAGE_CACHE_SIZE);
>
> Does the compiler not warn that you're assigning void to 'ret'?  Or was
> there some other SNAFU sending these patches?
>

I'm sorry, my fault :) As I said in 00 these patches are completely 
*not* tested, it was only a "quick coding & review" to understand if 
someone can see any problem to this kind of implementation, since I 
touched several points in the kernel. So there is still on-going work 
and I need to do several tests. Maybe I had to add the RFC tag, sorry again.

Marco
