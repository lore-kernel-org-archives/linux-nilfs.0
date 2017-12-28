From: "Ethy H. Brito" <ethy.brito-INItM/9t2qJfJ/NunPodnw@public.gmane.org>
Subject: changing CP's create time
Date: Thu, 28 Dec 2017 12:03:36 -0200
Message-ID: <20171228120336.2b53a10c@babalu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Hi

What are the implications of changing the cp_create value for a bunch of
control points?

Motivation: I stumbled in this: 
NILFS: bad btree node (blocknr=115718887) ... 
and I decided to backup and recreate the partition since I could not find
any solution "googgling" for an answer.

(btw: any suggestions is really appreciated to solve this "bad btree" problem)

But when I rsync the data do another nilfs2 partition, snapshot by snapshot,
each "cp_create" is stamped with today's date.
Since I have a script that deletes all CP's older than 60 days, it will be a
problem to guess what do delete as all CP's will have almost the same
timestamp.

I probably doing it the wrong way but nothing clever came to my mind and I
must have this operation done by Tuesday morning when the folks returns to work.

So I decided to thought changing the cp_create values back in time to
resemble the original time of creation and hence the first question.

Again, any suggestions are welcome to save my you know what.

Regards

Ethy
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
