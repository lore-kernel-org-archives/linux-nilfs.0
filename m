From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] nilfs2: fix data loss with mmap()
Date: Fri, 19 Sep 2014 08:41:07 +0900 (JST)
Message-ID: <20140919.084107.1306407610758412217.konishi.ryusuke@lab.ntt.co.jp>
References: <1411052185-8118-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<1411052185-8118-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<20140918121708.c9e9678c9ea76b057377d843@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=ndRgdjS7Jk3nI09SHBhjvbnJJBTHZhTSTBVWWFZFzJ8=;
        b=PTJmzyVcWii53TnmMmySqBELnjCUEBNsJKTTVD1oA8uo9/VY4TVgAQpyy315u94Kto
         E2YwPfnIc6UGbpCiMhYUplogl6MSLO01lGH7PNT4mJijYn190bsgQZmojhE8ucEOwEMz
         7OkvDzVnk1nlfOL1+Bi8w5OA11l0b75sXp7qeQ/U9+4WtuCOk35bmsgLpxcms3GAIYUM
         KfLUSe19FeYzW2wKX0R0SES9kBioSkHmTiiY3/AsuUy6Bnun5PpnV4SZ588ScjehJnHq
         F+4sne1A55kjqfplrvk9g9d2FX9FlsVjkJq/8SGdPRNy8hbEx0WbJra4JHjSGJ/BsuQ6
         uAZw==
In-Reply-To: <20140918121708.c9e9678c9ea76b057377d843-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>

On Thu, 18 Sep 2014 12:17:08 -0700, Andrew Morton wrote:
> On Thu, 18 Sep 2014 23:56:25 +0900 Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
> 
>> From: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
>> 
>> This bug leads to reproducible silent data loss, despite the use of
>> msync(), sync() and a clean unmount of the file system. It is easily
>> reproducible with the following script:
>> 
>> ...
>>
>> --- a/fs/nilfs2/inode.c
>> +++ b/fs/nilfs2/inode.c
>> @@ -219,10 +219,10 @@ static int nilfs_writepage(struct page *page, struct writeback_control *wbc)
>>  
>>  static int nilfs_set_page_dirty(struct page *page)
>>  {
>> +	struct inode *inode = page->mapping->host;
>>  	int ret = __set_page_dirty_nobuffers(page);
>>  
>>  	if (page_has_buffers(page)) {
>> -		struct inode *inode = page->mapping->host;
>>  		unsigned nr_dirty = 0;
>>  		struct buffer_head *bh, *head;
>>  
>> @@ -245,6 +245,10 @@ static int nilfs_set_page_dirty(struct page *page)
>>  
>>  		if (nr_dirty)
>>  			nilfs_set_file_dirty(inode, nr_dirty);
>> +	} else if (ret) {
>> +		unsigned nr_dirty = 1 << (PAGE_SHIFT - inode->i_blkbits);
> 
> It's quite cosmetic, but it is conventional to use PAGE_CACHE_SHIFT here.

Agreed.

Thanks,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
