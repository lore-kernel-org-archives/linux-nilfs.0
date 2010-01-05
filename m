From: "John Mazza" <johnm-ssvs9p6LcFAqDJ6do+/SaQ@public.gmane.org>
Subject: Utilities & Usability
Date: Tue, 5 Jan 2010 08:39:05 -0500
Message-ID: <20D0961E8385B74FB47A1CBFE221DD99153728@exchg2.iservetech.local>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-class: urn:content-classes:message
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/options/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

I've been working with NILFS for a few weeks now, and find that the
underlying filesystem is a great solution to some problems that we are
trying to solve.  However, the userspace utilities are far too unwieldy
to work with as a practical matter.  

The only missing piece is some way to automatically (via cleanerd maybe)
create snapshots of the nearest checkpoint at an interval of "X"
minutes, with a lifetime of "Y" minutes.  Currently, there is no good
way to automate this process, and the system creates such a long list of
checkpoints that finding a good candidate for creating a "mountable
snapshot" to restore from is prohibitively time-consuming.  

Ideally, the behavior of the feature should create a snapshot every X
minutes from the checkpoint closest in time to the interval, and revert
to checkpoint status any that are older than "Y" minutes old.

Basically the goal is to keep a manageable number of snapshots to
minimize the impact of a corrupted database file.  Since backups are
done every 24 hours here, we would set the lifetime to 1440 minutes and
the interval to 15 minutes, thus limiting the worst-case data loss to 15
minutes, and with the advantage of only having to look through a list of
96 snapshots rather than potentially hundreds or thousands of
checkpoints. 

It looks like all the code exists currently to do this, but it needs to
be integrated a just a little bit more to enable this behavior. 
