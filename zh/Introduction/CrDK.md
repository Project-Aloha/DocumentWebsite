# Crane Development Kit
<h3 align="center">Project Crane 软件架构概览</h3>
<table border="0" width="100%" cellspacing="2" cellpadding="12" style="font-family: 'Segoe UI', Arial, sans-serif; text-align: center; border: 1px solid #ddd; border-radius: 4px;">
  <tbody>
    <tr>
      <td width="22%" bgcolor="#311B92" style="color: #ffffff; font-size: 14px;"><b>驱动</b></td>
      <td width="26%" bgcolor="#F5F3FF" style="border: 1px solid #D1C4E9; color: #512DA8; font-family: 'Consolas', monospace;"><b>GpioCrDxe</b></td>
      <td width="26%" bgcolor="#F5F3FF" style="border: 1px solid #D1C4E9; color: #512DA8; font-family: 'Consolas', monospace;"><b>GpioCrKmd</b></td>
      <td width="26%" bgcolor="#F5F3FF" style="border: 1px solid #D1C4E9; color: #512DA8; font-family: 'Consolas', monospace;"><b>GpioCrDriver</b></td>
    </tr>
    <tr>
      <td bgcolor="#311B92" style="color: #ffffff; font-size: 14px;"><b>操作系统/内核无关库</b></td>
      <td colspan="3" bgcolor="#7E57C2" style="color: #ffffff; letter-spacing: 0.5px;">
        <b>Driver Libraries</b> <span style="font-size: 12px; opacity: 0.9;">(GpioLib / InterruptLib)</span>
      </td>
    </tr>
    <tr>
      <td bgcolor="#311B92" style="color: #ffffff; font-size: 14px;"><b>系统/内核抽象层</b></td>
      <td colspan="3" bgcolor="#5E35B1" style="color: #ffffff; letter-spacing: 0.5px;">
        <b>OS / Kernel Abstract Layer (KAL)</b>
      </td>
    </tr>
    <tr>
      <td bgcolor="#311B92" style="color: #ffffff; font-size: 14px;"><b>平台</b></td>
      <td bgcolor="#1A237E" style="color: #E8EAF6; border-right: 1px solid #3949AB;"><b>UEFI</b></td>
      <td bgcolor="#1A237E" style="color: #E8EAF6; border-right: 1px solid #3949AB;"><b>Win</b></td>
      <td bgcolor="#1A237E" style="color: #E8EAF6;"><b>RTOS</b></td>
    </tr>
  </tbody>
</table>
<div style="text-align: right; font-size: 10px; color: #999; opacity: 0.5; margin-top: 4px;">
  © Project-Aloha
</div>