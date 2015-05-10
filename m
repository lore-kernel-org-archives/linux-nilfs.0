From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2 7/9] nilfs2: ensure that all dirty blocks are
 written out
Date: Sun, 10 May 2015 12:31:12 +0900 (JST)
Message-ID: <20150510.123112.1905533372511793847.konishi.ryusuke@lab.ntt.co.jp>
References: <1430647522-14304-8-git-send-email-andreas.rohner@gmx.net>
	<20150509.211741.1463241033923032068.konishi.ryusuke@lab.ntt.co.jp>
	<554E6B7E.8070000@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=pLs7XfQJDeTTghzu8vJts006OoszU9nrvmvOCeFHi0A=;
        b=SoBWCG9iReesU5n/7/mMUVxsWFpQO+tds6DKVvhVixef9JzJg8CV89Gjyatdf3opwi
         ihur2b7BaC3MllHrsU+EMF6UmRtCg8hm5s4A09HpDfMo7POGaasvDYGSjXxWApKJLa0k
         EkMrndGRAPdXUqYyQ9zv+zciwsjZikf43vnta5lG82Pvy8+unqxk+DGLE4f5PByR3otZ
         JR0Ln50NuTdTRY5Mn+/P0D8j+khfiivJCXGy2AwhA+mBcTeadfpidxdbSiR2PA9EasfD
         fOatgcR2pIJKk1E+lqagyZJ2FEPhttVwAIEW13qQ0UN7WJ6M1VlGvSGAYZF5jBVbwF6W
         lfDw==
In-Reply-To: <554E6B7E.8070000-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 09 May 2015 22:18:06 +0200, Andreas Rohner wrote:
> On 2015-05-09 14:17, Ryusuke Konishi wrote:
>> On Sun,  3 May 2015 12:05:20 +0200, Andreas Rohner wrote:
>>> @@ -1055,6 +1070,55 @@ static int nilfs_segctor_scan_file_dsync(struct nilfs_sc_info *sci,
>>>  	return err;
>>>  }
>>>  
>>> +/**
>>> + * nilfs_segctor_propagate_sufile - dirties all needed SUFILE blocks
>>> + * @sci: nilfs_sc_info
>>> + *
>>> + * Description: Dirties and propagates all SUFILE blocks that need to be
>>> + * available later in the segment construction process, when the SUFILE cache
>>> + * is flushed. Here the SUFILE cache is not actually flushed, but the blocks
>>> + * that are needed for a later flush are marked as dirty. Since the propagation
>>> + * of the SUFILE can dirty DAT entries and vice versa, the functions
>>> + * are executed in a loop until no new blocks are dirtied.
>>> + *
>>> + * Return Value: On success, 0 is returned on error, one of the following
>>> + * negative error codes is returned.
>>> + *
>>> + * %-ENOMEM - Insufficient memory available.
>>> + *
>>> + * %-EIO - I/O error
>>> + *
>>> + * %-EROFS - Read only filesystem (for create mode)
>>> + */
>>> +static int nilfs_segctor_propagate_sufile(struct nilfs_sc_info *sci)
>>> +{
>>> +	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
>>> +	unsigned long ndirty_blks;
>>> +	int ret, retrycount = NILFS_SC_SUFILE_PROP_RETRY;
>>> +
>>> +	do {
>>> +		/* count changes to DAT file before flush */
>>> +		ret = nilfs_segctor_scan_file(sci, nilfs->ns_dat,
>>> +					      &nilfs_sc_prop_ops);
>> 
>> Use the previous nilfs_segctor_propagate_file() here.
>> 
>>> +		if (unlikely(ret))
>>> +			return ret;
>>> +
>>> +		ret = nilfs_sufile_flush_cache(nilfs->ns_sufile, 1,
>>> +					       &ndirty_blks);
>>> +		if (unlikely(ret))
>>> +			return ret;
>>> +		if (!ndirty_blks)
>>> +			break;
>>> +
>>> +		ret = nilfs_segctor_scan_file(sci, nilfs->ns_sufile,
>>> +					      &nilfs_sc_prop_ops);
>> 
>> Ditto.
>> 
>>> +		if (unlikely(ret))
>>> +			return ret;
>>> +	} while (ndirty_blks && retrycount-- > 0);
>>> +
>> 
>> Uum. This still looks to have potential for leak of dirty block
>> collection between DAT and SUFILE since this retry is limited by
>> the fixed retry count.
> 
> Yes unfortunately.
> 
>> How about adding function temporarily turning off the live block
>> tracking and using it after this propagation loop until log write
>> finishes ?
> 
> I think this is a great idea.
> 
>> It would reduce the accuracy of live block count, but is it enough ?
>> How do you think ? 
> 
> I would suggest to iterate through the loop in
> nilfs_segctor_propagate_sufile() at least once or twice, so that we can
> count most of the DAT-File blocks. After that we temporarily turn off
> the live block tracking until the end of the segment construction. This
> should only lead to small inaccuracies.

Agreed, that sounds better.

>> We have to eliminate the possibility of the leak
>> because it can cause file system corruption.  Every checkpoint must be
>> self-contained.
> 
> I didn't realize that it could cause file system corruption.
> 
>>> +	return 0;
>>> +}
>>> +
>>>  static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
>>>  {
>>>  	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
>>> @@ -1160,6 +1224,13 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
>>>  		}
>>>  		sci->sc_stage.flags |= NILFS_CF_SUFREED;
>>>  
>> 
>>> +		if (mode == SC_LSEG_SR &&
>> 
>> This test ("mode == SC_LSEG_SR") can be removed.  When the thread
>> comes here, it will always make a checkpoint.
>> 
>>> +		    nilfs_feature_track_live_blks(nilfs)) {
>>> +			err = nilfs_segctor_propagate_sufile(sci);
>>> +			if (unlikely(err))
>>> +				break;
>>> +		}
>>> +
>>>  		err = nilfs_segctor_scan_file(sci, nilfs->ns_sufile,
>>>  					      &nilfs_sc_file_ops);
>>>  		if (unlikely(err))
>>> diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
>>> index a48d6de..5aa7f91 100644
>>> --- a/fs/nilfs2/segment.h
>>> +++ b/fs/nilfs2/segment.h
>>> @@ -208,7 +208,8 @@ enum {
>>>   */
>>>  #define NILFS_SC_CLEANUP_RETRY	    3  /* Retry count of construction when
>>>  					  destroying segctord */
>>> -
>>> +#define NILFS_SC_SUFILE_PROP_RETRY  10 /* Retry count of the propagate
>>> +					  sufile loop */
>> 
>> How many times does the propagation loop has to be repeated
>> until it converges ?
> 
> Most of the time it runs only once, because all the blocks are already
> dirty, but sometimes it can go on for more than 10 iterations.

Thank you for the reply.  I got the situation.

Regards,
Ryusuke Konishi.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
