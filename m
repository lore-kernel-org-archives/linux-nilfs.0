From: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: [PATCH v2 5/9] nilfs2: add SUFILE cache for changes to
 su_nlive_blks field
Date: Sun, 10 May 2015 11:09:29 +0900 (JST)
Message-ID: <20150510.110929.300032019699467562.konishi.ryusuke@lab.ntt.co.jp>
References: <1430647522-14304-6-git-send-email-andreas.rohner@gmx.net>
	<20150509.130900.223492430584220355.konishi.ryusuke@lab.ntt.co.jp>
	<554E626A.2030503@gmx.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        bh=z+Q/g385NLMRiiXis4upe8ud746pQt240zGS8rgpytc=;
        b=Oz8lHqNM+zBiVs/m7iMynGn5Vf7c105qaPRIvrW7aMIPCnLHq3ytreATkoXysppliJ
         SFTdch2/h1J/DQXSXpj1aQKDT8o1EtDlXMJi6Q6DSbm5zyPFgX2yYvFA64USUpP/RYxh
         6GSoLHcvFDz71eHixnDiQ8P9OKs9HguEDST3j34XhL8VHciT8TxSr4zhWEOuXLpBFxBi
         qMXRU1b0N99RwJbdC2djGfNW+wXsuDC0lntqMTCTxlUSKFYTw+zCCmD1xu3hOyTNchk+
         xG9ayc2EN8D9leZcXmqN6gcySMkGwWehKICW803BBZAG1FhYuReA2hMa4TJss95P2X+k
         zDqA==
In-Reply-To: <554E626A.2030503-hi6Y0CQ0nG0@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: Andreas Rohner <andreas.rohner-hi6Y0CQ0nG0@public.gmane.org>
Cc: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, 09 May 2015 21:39:22 +0200, Andreas Rohner wrote:
> On 2015-05-09 06:09, Ryusuke Konishi wrote:
>> On Sun,  3 May 2015 12:05:18 +0200, Andreas Rohner wrote:
<snip>
>>> +	lock = bgl_lock_ptr(&sui->nlive_blks_cache_bgl, (unsigned int)group);
>>> +	spin_lock(lock);
>>> +	node->values[segnum & ((1 << NILFS_SUFILE_CACHE_NODE_SHIFT) - 1)] += 1;
>>> +	sui->nlive_blks_cache_dirty = 1;
>>> +	spin_unlock(lock);
>>> +	rcu_read_unlock();
>>> +
>>> +	return 0;
>>> +}
>> 
>> Consider using cmpxchg() or atomic_inc(), and using

>> NILFS_SUFILE_CACHE_NODE_MASK to mask segnum.

Sorry, I meant NILFS_SUFILE_CACHE_NODE_COUNT as below.

>> The following is an
>> example in the case of using cmpxchg():
>> 
>> 	__u32 old, new, *valuep;
>> 	...
>> 	old = node->values[segnum & (NILFS_SUFILE_CACHE_NODE_COUNT - 1)];
>> 	do {
>> 		old = ACCESS_ONCE(*valuep);
>> 		new = old + 1;
>> 	} while (cmpxchg(valuep, old, new) != old);
>> 
>> 	sui->nlive_blks_cache_dirty = 1;
>> 
>> 	rcu_read_unlock();
>> 	return 0;
>> }
>> 
>> The current atomic_xxxx() macros are actually defined in the same way
>> to the reduce overheads in smp environment.
>> 
>> Using atomic_xxxx() is more preferable but formally it requires
>> initialization with "atomic_set(&counter, 0)" or "ATOMIC_INIT(0)" for
>> every element.  I don't know whether initialization with memset()
>> function is allowed or not for atomic_t type variables.
> 
> Ok, but I would also have to use cmpxchg() in
> nilfs_sufile_flush_cache_node(), if the value needs to be set to 0.
> 
> Currently the cache is only flushed during segment construction, so
> there should be no concurrent calls to nilfs_sufile_dec_nlive_blks().
> But I thought it would be best do design a thread safe flush function.

You don't have to use cmpxchg() if you just want to set the value
to 0 since store operation is already atomic (see implementation of
atomic_set).

Do you mean atomic substraction is needed in
nilfs_sufile_flush_cache_node() ?

If so, using cmpxchg() is right.  But, note that, under the premise,
nilfs_sufile_shrink_cache() may free counters with a non-zero value.

At present, this is not a problem because nilfs_sufile_shrink_cache()
is called within nilfs_segctor_do_construct().  And, even when we add
its callsite in destructor of sufile, ignoring counters with a
non-zero value is not critical.

<snip>
>>> +void nilfs_sufile_shrink_cache(struct inode *sufile)
>>> +{
>>> +	struct nilfs_sufile_info *sui = NILFS_SUI(sufile);
>>> +	struct nilfs_sufile_cache_node *node;
>>> +	struct radix_tree_iter iter;
>>> +	void **slot;
>>> +
>> 
>>> +	/* prevent flush form running at the same time */
>> 
>> "flush from" ?
> 
> Yes that is a typo. It should be "flush from".
> 
>>> +	down_read(&NILFS_MDT(sufile)->mi_sem);
>> 
>> This protection with mi_sem seems to be needless because the current
>> implementation of nilfs_sufile_shrink_cache() doesn't touch buffers of
>> sufile.  The delete operation is protected by a spinlock and the
>> counter operations are protected with rcu.  What does this
>> down_read()/up_read() protect ?
> 
> It is intended to protect against a concurrently running
> nilfs_sufile_flush_cache() function. This should not happen the way the
> functions are called currently, but I wanted to make them thread safe.
> 
> In nilfs_sufile_flush_cache() I use references to nodes outside of the
> spinlock, which I am not allowed to do if they can be deallocated at any
> moment.

Ok, that's reasonable.	Thanks for detail explanation.

Regards,
Ryusuke Konishi

> I cannot hold the spinlock for the entire flush, because
> nilfs_sufile_flush_cache_node() needs to be able to sleep. I cannot use
> a mutex instead of a spinlock, because this would lead to a potential
> deadlock:
> 
> nilfs_sufile_alloc_cache_node():
> 1. bmap->b_sem
> 2. sui->nlive_blks_cache_lock
> 
> nilfs_sufile_flush_cache_node():
> 1. sui->nlive_blks_cache_lock
> 2. bmap->b_sem
> 
> So I decided to "abuse" mi_sem for this purpose, since I already need to
> hold mi_sem in nilfs_sufile_flush_cache().

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
