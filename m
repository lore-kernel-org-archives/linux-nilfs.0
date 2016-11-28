From: Michael Conrad <mconrad-HsDW+lVSy7tZ66HEZ9PjWw@public.gmane.org>
Subject: Re: Kernel Bug on Linux 4.1.31, possibly nilfs, not sure (correction)
Date: Mon, 28 Nov 2016 13:08:14 -0500
Message-ID: <f19bca1a-6b9e-f1eb-26ff-09e0674504a7@intellitree.com>
References: <bd7164ee-8641-a950-3b6b-211f504013a5@intellitree.com>
 <86ef5dca-d23a-7d11-08cb-5e065da63d63@intellitree.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <86ef5dca-d23a-7d11-08cb-5e065da63d63-HsDW+lVSy7tZ66HEZ9PjWw@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-nilfs.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 11/28/2016 1:02 PM, Michael Conrad wrote:
> Hello, I found a bug that might be related.
>
> https://patchwork.kernel.org/patch/9339843/
>
> On several of my crash dumps, I saw it die in 
> "memcg_drain_all_list_lrus" and found this mentioned in a bug where 
> FUSE was calling functions to modify the radix tree directly in a way 
> that other kernel developers weren't expecting.  (I don't fully 
> understand the details)
>
> Our systems that are crashing are not using the FUSE driver for 
> anything, but the crashes still coincide with nilfs2 activity.  Is 
> there a chance nilfs is affected by this same situation?
>
> I've attached another example crash log.  We're still on 4.1.31, but 
> will move to 4.1.35 soon.
>
> -Mike 

Apologies, this system is actually running kernel 4.1.22
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
