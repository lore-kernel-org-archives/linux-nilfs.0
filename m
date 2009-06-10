From: Luis Useche <luis-43oy+cWvsXk3uPMLIKxrzw@public.gmane.org>
Subject: Stressing GC
Date: Wed, 10 Jun 2009 17:08:59 -0400
Message-ID: <20090610210859.GA17619@apu.cs.fiu.edu>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi Guys,

I was doing some experiments on nilfs2 to stress the garbage collection
with different file system usage. Unfortunately, it was unable to pass the
first test since nilfs reports no space available eventhough there are no
files in the file system! I guess the GC is not collecting space fast
enough and the file system ends up with no space available.

Do you have any workaround to this problem?

Best,
-- 
Luis Useche <luis-43oy+cWvsXk3uPMLIKxrzw@public.gmane.org>
Ph.D. Student
Florida International University
