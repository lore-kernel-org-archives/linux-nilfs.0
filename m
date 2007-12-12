From: amagai-sG5X7nlA6pw@public.gmane.org
Subject: Re: NILFS - is this "CDP" ?
Date: Wed, 12 Dec 2007 17:23:12 +0900 (JST)
Message-ID: <200712120823.lBC8NCm9030708@nuesun.nue.org>
References: <20813635@web.de>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Received: by mhns.core.ntt.co.jp (8.14.1/mhns*core.mx13/TLSv1/SSLv3);
	Wed, 12 Dec 2007 17:23:33 +0900 (JST)
	<200712120823.lBC8NFsG042646-L3Bwnc4fnxrSADF8LgYVInf5DAMn2ifp@public.gmane.org> sender
	amagai-sG5X7nlA6pw@public.gmane.org for <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org> from nuesun.isle.ecl.net
	163.138.3.77
Received: by nuesun.isle.ecl.net (8.13.8/eclnet*isle.mxn2/);
	Wed, 12 Dec 2007 17:23:12 +0900 (JST)
	<200712120823.lBC8NCm9030708-vVVTaDpzuSIg7PIzrqgn9Q@public.gmane.org> sender
	amagai-sG5X7nlA6pw@public.gmane.org for from 
In-Reply-To: <20813635-S0/GAf8tV78@public.gmane.org>
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
Content-Type: TEXT/PLAIN; charset="us-ascii"
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,

> is the "continuous snapshotting" feature NILFS offers comparable to
> what storage vendors often call CDP or "Continuous Data Protection",
> i.e. you can go back to any point in time of your data?

One of important purpose of NILFS is protection user data from 
user's mis-operations,  such as unexpected 'rm *' or file over written.
It's just CDP.

The word 'CDP' is used in many context, so I refer following
SNIA definition in my reply.  From point of the definition,
I copmare NILFS with CDP, 

> 1. Data changes are continuously captured or tracked. 
Yes, NILFS make checkpoint automatically and continuously.

> 2. All data changes are stored in a separate location from the primary
    storage
No, NILFS store data on single disk storage in LFS mannger,
there are no additional data transfer for checkpointing.


> 3. Recovery point objectives are arbitrary and need not be defined in
     advance of the actual recovery.
Yes. 

I hope this helps you.

Amagai Yoshiji

NILFS team, NTT
http://www.nilfs.org/

================================================================
SNIA CDP Definition
http://www.snia.org/forums/dmf/programs/data_protect_init/cdp/

Continuous data protection (CDP) is a methodology that continuously
captures or tracks data modifications and stores changes independent
of the primary data, enabling recovery points from any point in the
past. CDP systems may be block-, file- or application-based and can
provide fine granularities of restorable objects to infinitely
variable recovery points. So, according to this definition, all CDP
solutions incorporate these three fundamental attributes:

1. Data changes are continuously captured or tracked. 

2. All data changes are stored in a separate location from the primary
storage

3. Recovery point objectives are arbitrary and need not be defined in
advance of the actual recovery

A number of recognized technological approaches deliver CDP, including
block-, file- and application-based. Today, many vendors offer varying
degrees of support and awareness of specific application and data
environments. But regardless of the underlying technological approach
utilized, CDP can offer faster data retrieval, enhanced data
protection, and increased business continuity with lower overall cost
and complexity.

...
================================================================
