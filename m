From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH 1/1] nilfs2: fix potential memory overrun on inode
Date: Sat, 21 Feb 2015 09:22:08 +0900 (JST)
Message-ID: <20150221.092208.1795135375638032743.konishi.ryusuke@lab.ntt.co.jp>
References: <1424439995-613-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<1424439995-613-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<20150220135842.0cd5c9338316a8a20b6a604a@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=oNnbtwfj1ZD5y++l+7PO2hXTK/0EBmNo8j5ty2dcdMg=;
        b=OUWD4MBvLDb10bxoFeBNTI6w4Xe1JbxNqsuJRuYqerazNEdbraHN5xExa6rWMJjcd4
         imvJG8jl+UiD9MMnmAO/VzVRe93GrKVlbWq533HTKPVLRcKjTk9pEuGmXH24eJ8XJHpt
         ZcRWmRv9GRSFaaASNVJsx5t4cU4wkp8f0MSVgk3wQ/YvK+4+iQegdQRnAza9P9jIBP8p
         Rs2s74eGfXdWsUTUnGfbhi7oStD99dP63WnDE90sO5qUWFNks+kbeOERa1w8yR2DGq+I
         iakw+GSXvT4vEljD4IwNrEtPT9EUhEHF7CFjrZynzFhhclJO7cH5FgO3W43p51DIYNiS
         AzpQ==
In-Reply-To: <20150220135842.0cd5c9338316a8a20b6a604a@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nilfs@vger.kernel.org

On Fri, 20 Feb 2015 13:58:42 -0800, Andrew Morton wrote:
> On Fri, 20 Feb 2015 22:46:35 +0900 Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:
> 
>> Each inode of nilfs2 stores a root node of a b-tree, and it turned out
>> to have a memory overrun issue:
>> 
>> Each b-tree node of nilfs2 stores a set of key-value pairs and the
>> number of them (in "bn_nchildren" member of nilfs_btree_node struct),
>> as well as a few other "bn_*" members.
>> 
>> Since the value of "bn_nchildren" is used for operations on the
>> key-values within the b-tree node, it can cause memory access overrun
>> if a large number is incorrectly set to "bn_nchildren".
>> 
>> For instance, nilfs_btree_node_lookup() function determines the range
>> of binary search with it, and too large "bn_nchildren" leads
>> nilfs_btree_node_get_key() in that function to overrun.
>> 
>> As for intermediate b-tree nodes, this is prevented by a sanity check
>> performed when each node is read from a drive, however, no sanity
>> check has been done for root nodes stored in inodes.
>> 
>> This patch fixes the issue by adding missing sanity check against
>> b-tree root nodes so that it's called when on-memory inodes are read
>> from ifile, inode metadata file.
> 
> How would one trigger this overrun?  Mount an fs with a deliberately
> corrupted/inconsistent fs image?

Yes, this can be triggered by mounting an fs with a corrupted image
deliberately or by chance.

> Memory overrun sounds nasty so I'm thinking we add cc:stable to this
> one.  OK?

Agreed.

Ryusuke Konishi
