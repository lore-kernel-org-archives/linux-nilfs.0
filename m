From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH] lscp: always show snapshots, even if marked minor
Date: Wed, 10 Sep 2014 05:29:59 +0900 (JST)
Message-ID: <20140910.052959.1206474453162425922.konishi.ryusuke@lab.ntt.co.jp>
References: <1409600926-25385-1-git-send-email-dan@archlinux.org>
	<20140903.023057.865227985663964185.konishi.ryusuke@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=CsfJ4oO40Oh84+Jfn6mF74fxTVWxXCwWtXlgLkYaSXA=;
        b=v2lbsckot8dybMtmfxt7KMAc7NF5tS54MP8Ew1SPjADMqvOTmeGUAjhDGuZNPozH28
         Uldx1+SaCrBjrKSfAysN0NqKY1Se4EuMvxQCQNx38SNMRR+Yrjmj9zL6OJWEG46t+qid
         jSgZID0awmVVdC8KTnMk2tU4Dc407fv9/FHphCRTd3C8PTGu5PfDN18bw5q3ys+fliQQ
         8JYjTJXWxgssOeJGCGahdJlMIO060i/puiCzVce8t922g1a7WgfxdYnXDYm7ahEWO9S3
         ZjbZ2awYAVFQXPfNE+HD/x+aEn4JnQNoEdQQM+5vMnx1p1gPu0MUUgE+dGo7bdxH816r
         KGKQ==
In-Reply-To: <20140903.023057.865227985663964185.konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 03 Sep 2014 02:30:57 +0900 (JST), Ryusuke Konishi wrote:
> On Mon,  1 Sep 2014 14:48:46 -0500, Dan McGee wrote:
>> When the average user types `lscp` and doesn't see the snapshot they
>> just tried to make, it can be very confusing. Add an additional check
>> to ensure snapshots are never omitted from lscp output.
>> 
>> Signed-off-by: Dan McGee <dan-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>
>> ---
>> 
>> Thoughts? I notice this quite often due to a "snapshot-on-shutdown" job I have
>> running on my machine, and it is very odd to not see this snapshot listed next
>> time I boot up and run `lscp -r | less`.
>> 
>>  bin/lscp.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/bin/lscp.c b/bin/lscp.c
>> index 2de81b6..6803657 100644
>> --- a/bin/lscp.c
>> +++ b/bin/lscp.c
>> @@ -159,7 +159,7 @@ static int lscp_forward_cpinfo(struct nilfs *nilfs,
>>  			break;
>>  
>>  		for (cpi = cpinfos; cpi < cpinfos + n; cpi++) {
>> -			if (show_all || !nilfs_cpinfo_minor(cpi)) {
>> +			if (show_all || nilfs_cpinfo_snapshot(cpi) || !nilfs_cpinfo_minor(cpi)) {
>>  				lscp_print_cpinfo(cpi);
>>  				rest--;
>>  			}
> 
> "lscp -r" still doesn't show snapshots on minor checkpoints.
> The same change looks to be needed for lscp_backward_cpinfo().
> 
> Also, this patch suffered a checkpatch warning:
> 
>  $ scripts/checkpatch.pl ~/lscp-always-show-snapshots-even-if-marked-minor.patch
>  WARNING: line over 80 characters
>  #75: FILE: bin/lscp.c:162:
>  +		if (show_all || nilfs_cpinfo_snapshot(cpi) || !nilfs_cpinfo_minor(cpi)) {
>  
>  total: 0 errors, 1 warnings, 8 lines checked

I merged this patch anyway fixing the above checkpatch warning, and
added a complemental change to apply the same change for the reverse
mode ("lscp -r").

Regards,
Ryusuke Konishi
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
