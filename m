From: Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Some nilfs comments
Date: Tue, 06 Jan 2009 14:55:09 -0500
Message-ID: <1231271709.4888.27.camel@think.oraclecorp.com>
References: <1229568775.27170.134.camel@think.oraclecorp.com>
	<20081222.180719.88488712.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20081222.180719.88488712.ryusuke-sG5X7nlA6pw@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: Ryusuke Konishi <konishi.ryusuke-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

On Mon, 2008-12-22 at 18:07 +0900, Ryusuke Konishi wrote:
> > I haven't dug too deeply in yet, but if there are parts you're most
> > interested in comments on, please let me know.
> 
> Well, I feel that the following two matters are particularlly
> questionable and need to be checked:
> 

> - ioctl:
>   Ioctl interface (routines and structures) were implemented in an
>   own way.  These seems to be checked whether to comply with the rules
>   of ioctl design.
> 

It took me far too long to look at this, I'm sorry.  But, looking
through the ioctl code I think you'll have a few (easy to fix) problems.

struct nilfs_argv {
        void *v_base;
        size_t v_nmembs;        /* number of members */
        size_t v_size;          /* size of members */
        int v_index;
        int v_flags;
};

The structs that get passed from userland to kernel should use fixed
sized types.

I get around this by using u64s (and __u64s) everywhere.  It looks like
you have compat ioctls to fix this too, I find it easier to use the
fixed types.

Otherwise the ioctl code looks pretty reasonable.

-chris
