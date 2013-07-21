From: Vyacheslav Dubeyko <slava-yeENwD64cLxBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC] nilfs2: double bio_put() in nilfs_end_bio_write()
Date: Sun, 21 Jul 2013 16:50:36 +0400
Message-ID: <CEDFCC8D-B88C-4148-A3A1-5851233C2D41@dubeyko.com>
References: <20130719092603.GB22147@longonot.mountain> <8D04BC36-EF1A-4ED9-86CC-50F17A0EAA11@dubeyko.com> <20130720214043.GC5636@mwanda>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dubeyko.com; s=default;
	h=To:References:Message-Id:Content-Transfer-Encoding:Cc:Date:In-Reply-To:From:Content-Type:Mime-Version:Subject; bh=lAEaI8E7IXgeZD6mi+QiDhclsFeX6ZV0lTwFehfGQ7U=;
	b=QNixEsS+x2IRfLeefHQ/ABueaE6oVWF0cg56lkNK9IYnwiQGSOqFSq/g4EYNrpYECzCReZ5mYFZ2GhNdHaqefOQU60G/8yUUoYrLjFz686uIF9BVQK0ZCZ8ulTBXrWep;
In-Reply-To: <20130720214043.GC5636@mwanda>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: KONISHI Ryusuke <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, linux-nilfs <linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On Jul 21, 2013, at 1:40 AM, Dan Carpenter wrote:

> On Sat, Jul 20, 2013 at 01:10:23PM +0400, Vyacheslav Dubeyko wrote:
>>> diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
>>> index dc9a913..a660fd7 100644
>>> --- a/fs/nilfs2/segbuf.c
>>> +++ b/fs/nilfs2/segbuf.c
>>> @@ -346,7 +346,8 @@ static void nilfs_end_bio_write(struct bio *bio, int err)
>>> 	if (err == -EOPNOTSUPP) {
>>> 		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
>>> 		bio_put(bio);
>>> -		/* to be detected by submit_seg_bio() */
>>> +		/* to be detected by nilfs_segbuf_submit_bio() */
>>> +		return;
>> 
>> I think that simple return from the function is not right way. As I understand the code,
>> then we increment error count in segbuf's sb_err field and signalize about completion of
>> operation. So, from my viewpoint, it needs to remove the bio_put() call for the case of
>> (err == -EOPNOTSUPP) instead of return from function.
>> 
> 
> Do you think you could send that patch and give me a reported-by
> tag?  I feel weird signing off on it when I don't really understand
> this code...
> 

Ok, sure. I'll send the patch and continue discussion with Ryusuke
(if he will have objections).

Thank you for the report and fix suggestion.

With the best regards,
Vyacheslav Dubeyko.

> regards,
> dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
