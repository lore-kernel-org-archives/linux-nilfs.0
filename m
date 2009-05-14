From: "Michael Niederle" <mniederle-RbZlAiThDcE@public.gmane.org>
Subject: Re: users Digest, Vol 38, Issue 13
Date: Thu, 14 May 2009 19:39:16 +0200
Message-ID: <20090514193916.1d8e982e@simplux>
References: <mailman.1.1242270001.16807.users@nilfs.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <mailman.1.1242270001.16807.users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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

I'm evaluating nilfs as a replacement for the typical layered filesystem
approach (unionfs, aufs) used in live-systems.

nilfs performs incredibly well! Its sequential write / random read philosophy
is great for accessing pen-drives.

I have only one big problem: I twice corrupted the nilfs-superblock (due to
inproper shutdown) leading to a complete data loss each time.

The todo-list mentions that more copies of the superblock are needed. I
strongly agree! I think this should be one of the top items on the todo-list.

Greetings, Michael
