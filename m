From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: [PATCH v2] fs: Convert return type int to vm_fault_t
Date: Mon, 03 Sep 2018 11:13:10 +0900 (JST)
Message-ID: <20180903.111310.853324894545237861.konishi.ryusuke@lab.ntt.co.jp>
References: <20180830172547.GA4408@jordon-HP-15-Notebook-PC>
        <20180830163352.5a96cc721ce069bed95fdbe8@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NSX+pTaCSyP3Wnp4IRwBcUSmlRinWn3ytHgI9N+Ydms=;
        b=hjF+sFmWU5pNhvMZYIbQPVHpaFpNua17D7Efl4p4ebp/GRr46sT0hWBKsciHWOsgLz
         /4sGd1k/LvMsgHr/PHoORay2WuBuB1mrgr1aClrJk69lQpWLlN7bFa9os/aOShk/0hA6
         Q+rsuQjd8g/eD1nHM/yHJ6doQi7Ez1+DTGyvviQobAJIoayoj133RAnyBFt89E9T07gx
         HnLKpaSpVybRW30S8J7/1uqSnPS4oKga+Y6JXU+HJz74sqOF7jOpo2UMnZojLobFtdUT
         C2Ymmf90ZYfjMMeUEfN381DHTFKrkfTjOq4QCKBwZnolMRFiKkXXIXAlE+wXwWz8qR2y
         GYSA==
In-Reply-To: <20180830163352.5a96cc721ce069bed95fdbe8@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, viro@zeniv.linux.org.uk, tytso@mit.edu, adilger.kernel@dilger.ca, axboe@kernel.dk, darrick.wong@oracle.com, ebiggers@google.com, pombredanne@nexb.com, agruenba@redhat.com, gregkh@linuxfoundation.org, kemi.wang@intel.com, willy@infradead.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nilfs@vger.kernel.org

Hi Souptick,

On Thu, 30 Aug 2018 16:33:52 -0700, Andrew Morton wrote:
> On Thu, 30 Aug 2018 22:55:47 +0530 Souptick Joarder wrote:
> 
>> Return type for fault handlers  in ext4 and nilfs are
>> changed to use vm_fault_t.
>> 
>> Return type of block_page_mkwrite() is changed from
>> int to vm_fault_t. The function signature of
>> block_page_mkwrite() is changed to add one new parameter
>> int *err. This will provide a way for caller functions
>> to get error value along with return value and use it
>> further.
>> 
>> Return type of block_page_mkwrite_return() is also changed
>> to use new vm_fault_t type.
>> --- a/fs/nilfs2/file.c
>> +++ b/fs/nilfs2/file.c
>> @@ -51,13 +51,14 @@ int nilfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>>  	return err;
>>  }
>>  
>> -static int nilfs_page_mkwrite(struct vm_fault *vmf)
>> +static vm_fault_t nilfs_page_mkwrite(struct vm_fault *vmf)
> 
> nilfs_page_mkwrite() already has return type vm_fault_t in Linus's
> kernel, due to the now-merged
> fs-nilfs2-adding-new-return-type-vm_fault_t.patch.  Looks like a simple
> fix.

In the first patch in this thread, this return type change was
excluded correctly for nilfs_page_mkwrite() though the changelog was
inaccurate in that sense.

Please confirm your base point of the revised patch.

Regards,
Ryusuke Konishi


> 
> I'm beginning to feel vm_fault_t exhaustion.  Please remind me what
> benefit we're going to get out of all this churn?
> 
>> 
>> ...
>>
