From: Koji Sato <koji-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Garbage Collection Schemes
Date: Fri, 30 Nov 2007 09:59:00 +0900
Message-ID: <474F6054.9050905@osrg.net>
References: <200711261512.11121.jsa@gotroot.homeip.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <200711261512.11121.jsa-MJZuZBXGww0Jmq/UkTHWNaxOck334EZe@public.gmane.org>
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
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Hello John.
Sorry for my late reply.

> I am new to NILFS, so bear with me.
> 
> I would like to ask, (without reading the entire archive of messages) if
> any thought to other garbage collection schemes has been contemplated.
> 
> For instance: This file system looks like it might be very useful for 
> certain types of environments where N sequential revisions of documents
> must be maintained, regardless of the  age or how any given document relates
> to other documents.
> 
> Checkpoints do not seem to do this.
> 
> I would like to see garbage collection options that allow (for example)
> 10 copies retained (of EACH file), each bearing different dates.  
> 
> Garbage collection would erase the 11th (oldest copy) if, (and only if) the 
> other 10 all had different dates.  This prevents the situation where one user 
> (or rogue process) re-saving a document 15 times a day wipes out all prior 
> copies.
> 
> An option might be garbage collection not based on a NUMBER of iterations
> but rather a period of time (3 years, 7 years, etc, while still purging same 
> date (or same hour, minute, etc) copies.
> 
> This type of garbage collection is found almost nowhere, and this
> file system seems to be the closest possible candidate to do this.
> 
> There are applications, where a consistent representation of all 
> files at a specific point in time (snapshot or checkpoint) is LESS
> important than the ability to roll back individual documents to 
> a number of prior iterations or a number of years.
> 
> Legal documents, financial records, code version archiving, etc, all
> have these requirements.

In the current implementation, NILFS does not automatically create
snapshots. If daily or weekly snapshots are required to be made, the
chcp command should be periodically invoked (using cron or other
mechanisms). The implementation of the automatic snapshot creation based 
on user-defined retention policy is one of our future works. Please let 
us know if you have any suggestion or comment.

Thanks you.

-- 
Koji Sato
Open Source Software Computing Project
NTT Cyber Space Laboratories
Nippon Telegraph and Telephone Corporation
