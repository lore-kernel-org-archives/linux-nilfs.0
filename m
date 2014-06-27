From: dE <de.techno-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: nilfs_clean_segments: segment construction failed. (err=-2)
Date: Fri, 27 Jun 2014 12:51:55 +0530
Message-ID: <53AD1B93.9020309@gmail.com>
References: <53ABA8F3.3010606@gmail.com>	 <A863805F-8398-42B1-9BEA-35D4425E2404@dubeyko.com>	 <53ABB6F4.5050508@gmail.com> <1403789693.2609.14.camel@slavad-CELSIUS-H720>	 <53ACF691.5090203@gmail.com> <1403850646.2588.4.camel@slavad-CELSIUS-H720>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        bh=/G4R6LMJSh2psF94Joy5Grqh/pJE5bpmDCjBO7DcMV0=;
        b=oNRW1fEEPzA3awMatR9t6w+4r2oanehXzYScWq+pbsoo5isi08IlXdFnkzkXVrxcFY
         49RY7zAPJeCBlSTpjywRjN4cMt97gIh8cD6dczWHYc44promfaZbfAjfAROT3kynaCa/
         8dl8xRZ+E//MKSLZALxQFqmpLMCpsORqgRsJKq3D2mshB+tV1Rxt5SrZbcMc9GmYW8C5
         GuZyAtrgDpTqOc6TdvBmKm6sPngj1K9Z7vGQXs4OxRXgads7b/Zpeo7a5WhFdxQxO6L9
         R3XsBtuCp+TN2pvsWxUBeilAS+KI0G2mUX4tkmbIlognsbvzueYt6RVT7u2qDZH0aUPs
         0J/A==
In-Reply-To: <1403850646.2588.4.camel@slavad-CELSIUS-H720>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 06/27/14 12:00, Vyacheslav Dubeyko wrote:
> On Fri, 2014-06-27 at 10:14 +0530, dE wrote:
>
> [snip]
>> I can confirm that at 4K block size, this issue never existed. It
>> started happening when I reduced the block size to improve write and
>> read seek performance when very small amounts of data was being
>> read/written.
>>
>> Yes, the FS was made at the specified day, but it was running
>> continuously since then.
>>
>> This problem triggers after running the programs for long amounts of
>> time. Like 1 day+ with GC running the background at low priority (idle
>> i/o). nilfs_cleanerd.conf --
>>
>> clean_check_interval    300
>> nsegments_per_clean     1
>> mc_nsegments_per_clean  1
>> cleaning_interval      0
>> mc_cleaning_interval   0
>> protection_period       0
>> min_clean_segments      100%
>> max_clean_segments      100%
>> selection_policy        timestamp       # timestamp in ascend order
>> retry_interval          300
>> use_mmap
>> log_priority            warning
>>
>> As of the nature of the program which's using files on the FS, it reads
>> and writes very small amounts of data from random places on a set of
>> files (which are reasonably large). Then programs themselves are running
>> at either real time class or normal class.
>>
>> The bug triggers when I exit the program (which are all of similar nature).
>>
>> I tried to reproduce this issue by doing random write using the 'seeker'
>> tool, but it didn't trigger. So it triggers specifically on existing the
>> program.
>>
>> You may like to install the Bitcoin qt wallet from your repositories
>> (maybe it's reproducible with bitcoind client also) and after a day or 2
>> of running with the above nilfs_cleanerd, try exiting the program. You
>> may trigger the bug.
> Great. Thank you. I'll try to reproduce the issue.
>
> One more question. Do you use this file system as rootfs or not? I
> suppose that it's not rootfs file system, as I remember your previous
> description of the issue.
>
> Thanks,
> Vyacheslav Dubeyko.
>
>

No no... it's the data directory of the bitcoin-qt/bitcoind application 
(~/.bitcoin is a symlink to .bitcoin which is on a nilfs dir).

If you you see, a full bitcoin wallet is a stress test for nilfs cause 
it results in a HUGE number of garbage blocks.

Initially it's not going to be a challenge, but later on, as Bitcoin 
became more popular, the no. of  Bitcoin transactions dramatically 
increased, this increase the i/o on the device cause the wallet will 
verify each transaction as it downloads the blockchain (or old 
transactions).

Thanks for your corporation.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
