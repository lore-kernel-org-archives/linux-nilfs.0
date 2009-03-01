From: nilfs-MZZvbRqs/9F0RdzJJlgK+g@public.gmane.org
Subject: Dump tools for checkpoints
Date: Sun, 01 Mar 2009 01:57:18 +0100
Message-ID: <2883.84.133.202.72.1235869032.squirrel@ssl.its-beck.de>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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

Hi,

a great feature would be a tool to dump all filesystem changes since a
given checkpoint up to the newest available cp. The resulting file could
be fed to another filesystem for replication.

For a start, two tools: One to create and one to execute a binary dump.

Other projects can develop on top of these. A networked client / server to
keep a remote site in sync in master / slave style, for example. But some
self-made scripts could pipe the dump files between systems as well.

This would be much faster, compared to rsync and similar tools which need
to scan the source system.

Greetings,

Pierre Beck
